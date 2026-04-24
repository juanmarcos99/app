import 'package:app/core/core.dart';
import 'package:app/core/share/domain/use_cases/sync/get_pending_sync_tasks_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final RegisterPatient registerPatient;
  final LoginUser loginUser;
  final ChangePassword changePassword;
  final RememberUser saveUser;
  final SavePassword savePassword;
  final GetRememberedUsers getRememberedUsers;
  final GetPassword getPassword;
  final AddToSyncQueueUseCase addToSyncQueueUseCase;
  final RegisterRemoteUser registerRemoteUser;
  final ChangeRemotePasswordUseCase changeRemotePassword;
  final GetPendingSyncTasksUseCase getPendingSyncTasksUseCase;
  final ProcessFullSyncQueueUseCase processFullSyncQueueUseCase;

  int? _userId;
  User? user;

  AuthBloc(
    this.registerUser,
    this.loginUser,
    this.registerPatient,
    this.changePassword,
    this.saveUser,
    this.savePassword,
    this.getRememberedUsers,
    this.getPassword,
    this.addToSyncQueueUseCase,
    this.registerRemoteUser,
    this.changeRemotePassword,
    this.getPendingSyncTasksUseCase,
    this.processFullSyncQueueUseCase,
  ) : super(const AuthInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        final generatedId = IdGenerator.generate();
        final hashedUser = event.user.copyWith(
          id: generatedId,
          passwordHash: PasswordHasher.hash(event.user.passwordHash),
        );

        // Registro Local
        _userId = await registerUser(hashedUser);
        if (_userId == -2) {
          emit(UserNameExist());
          return;
        }

        user = hashedUser.copyWith(id: _userId);

        // Éxito local
        if (user!.role == 'patient') {
          emit(UserRegistrated(user!));
        } else {
          emit(UserFullyRegistrated(user!));
        }

        // 2. Intento de Registro Remoto
        try {
          final pendingTasks = await getPendingSyncTasksUseCase();
          if (pendingTasks.isEmpty) {
            await registerRemoteUser(user!);
          } else {
            throw ServerException(
              "no se puede subir a la nube, la cola tiene elementos pendientes",
            );
          }
        } on ServerException catch (e) {
          // Notificamos el error remoto
          emit(
            RemoteError(
              'Guardado localmente. Pendiente de sincronizar: ${e.message}',
            ),
          );

          // Creamos la tarea con el payload manual
          final task = SyncTaskModel(
            endpoint: 'users',
            userId: _userId!,
            method: 'INSERT',
            payload: {
              'id': user!.id,
              'name': user!.name,
              'lastName': user!.lastName,
              'email': user!.email,
              'phoneNumber': user!.phoneNumber,
              'userName': user!.userName,
              'passwordHash': user!.passwordHash,
              'role': user!.role,
            },
          );

          try {
            await addToSyncQueueUseCase(task);
            debugPrint(
              'Tarea de sincronización agregada exitosamente para el usuario ${user!.userName}',
            );
          } catch (e) {
            emit(SyncError('Error al agregar a la cola de sincronización: $e'));
            debugPrint("Error al añadir la queue");
          }
        }
      } on LocalDataBaseException catch (e) {
        emit(AuthFailure('Error local: ${e.message}'));
      } catch (e) {
        emit(AuthFailure('Error inesperado: $e'));
      }
    });

    on<RegisterPatientEvent>((event, emit) async {
      if (_userId == null) {
        emit(
          const AuthFailure('Aún no hay userId para registrar el paciente.'),
        );
        return;
      }
      emit(AuthLoading());
      try {
        final patientWithId = event.patient.copyWith(
          userId: _userId,
          id: IdGenerator.generate(),
        );
        await registerPatient(patientWithId);
        emit(UserFullyRegistrated(user!));
      } catch (e) {
        emit(
          AuthFailure(
            'Error al registrar paciente en la base de datos local : $e',
          ),
        );
      }
    });

    on<LoginUserEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        // Hashear contraseña para comparar con BD
        final hashedPassword = PasswordHasher.hash(event.password);

        final loggedUser = await loginUser(event.username, hashedPassword);
        if (loggedUser != null) {
          if (event.rememberMe) {
            await saveUser(event.username);
            await savePassword(event.username, event.password); // texto plano
          }
          emit(UserLoggedIn(loggedUser));
        } else {
          emit(
            const AuthFailure(
              'Credenciales inválidas, por favor rectifiquelas',
            ),
          );
        }
      } catch (e) {
        emit(AuthFailure('Error al iniciar sesión: $e'));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        // 1. Lógica Local (Hasheo y Verificación)
        final currentHashed = PasswordHasher.hash(event.currentPassword);
        final newHashed = PasswordHasher.hash(event.newPassword);
        final loggedUser = await loginUser(event.username, currentHashed);

        if (loggedUser == null) {
          emit(
            const AuthFailure(
              'Credenciales inválidas, por favor rectifiquelas',
            ),
          );
          return;
        }

        // 2. Aplicar cambio localmente de inmediato
        await changePassword(event.username, newHashed);
        await savePassword(event.username, event.newPassword);

        // Notificamos éxito local (La UI ya puede reaccionar)
        emit(UserPasswordChanged());

        // 3. Intento de Sincronización Remota (Aislado)
        try {
          final pendingTasks = await getPendingSyncTasksUseCase();

          if (pendingTasks.isNotEmpty) {
            throw ServerException("Cola de sincronización activa");
          }

          // Intento subir a Supabase
          await changeRemotePassword(event.username, newHashed);
        } catch (e) {
          // Si llega aquí, es porque hay tareas pendientes O falló la conexión
          // No emitimos AuthFailure porque localmente YA se cambió.

          emit(
            RemoteError(
              'Cambio guardado localmente. Pendiente de sincronizar.',
            ),
          );

          final task = SyncTaskModel(
            userId: loggedUser.id!,
            endpoint: 'users',
            method: 'UPDATE',
            payload: {'id': loggedUser.id, 'passwordHash': newHashed},
          );

          try {
            await addToSyncQueueUseCase(task);
            debugPrint(
              'Tarea de cambio de pass encolada para ${loggedUser.userName}',
            );
          } catch (queueError) {
            emit(SyncError('Error al guardar en cola: $queueError'));
          }
        }
      } catch (e) {
        debugPrint('Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr crítico: $e');
        emit(AuthFailure('Error crítico: $e'));
      }
    });

    on<LoadRememberedUsersEvent>((event, emit) async {
      emit(const AuthLoading());
    
      
      try {
        await processFullSyncQueueUseCase();
        final users = await getRememberedUsers();
        emit(RememberUsersLoaded(users));
      } catch (e) {
        emit(AuthFailure('Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr $e'));
      }
    });

    on<LoadPasswordEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        // Recuperar contraseña recordada en texto plano
        final password = await getPassword(event.username);
        emit(PasswordLoaded(password!));
      } catch (e) {
        emit(AuthFailure('Error al cargar contraseña: $e'));
      }
    });
  }
}
