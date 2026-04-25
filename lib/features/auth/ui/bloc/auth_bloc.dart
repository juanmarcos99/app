import 'package:app/core/core.dart';
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
        final userId = await registerUser(hashedUser);
        if (userId == -2) {
          emit(UserNameExist());
          return;
        }

        final fullUser = hashedUser.copyWith(id: userId);

        // Éxito local
        if (fullUser.role == 'patient') {
          emit(UserRegistrated(fullUser));
        } else {
          emit(UserFullyRegistrated(fullUser));
        }

        // 2. Intento de Registro Remoto
        try {
          final pendingTasks = await getPendingSyncTasksUseCase();
          if (pendingTasks.isEmpty) {
            await registerRemoteUser(fullUser);
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
            userId: userId,
            method: 'INSERT',
            payload: {
              'id': fullUser.id,
              'name': fullUser.name,
              'lastName': fullUser.lastName,
              'email': fullUser.email,
              'phoneNumber': fullUser.phoneNumber,
              'userName': fullUser.userName,
              'passwordHash': fullUser.passwordHash,
              'role': fullUser.role,
            },
          );

          try {
            await addToSyncQueueUseCase(task);
            debugPrint(
              'Tarea de sincronización agregada exitosamente para el usuario ${fullUser.userName}',
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
      if (event.patient.userId == 0) {
        emit(
          const AuthFailure('Aún no hay userId para registrar el paciente.'),
        );
        return;
      }
      emit(const AuthLoading());
      try {
        final patientWithId = event.patient.copyWith(
          id: IdGenerator.generate(),
        );
        await registerPatient(patientWithId);
        emit(UserFullyRegistrated(event.user));
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
      } catch (e) {
        debugPrint('Error procesando sync queue en login: $e');
      }

      try {
        final users = await getRememberedUsers();
        emit(RememberUsersLoaded(users));
      } catch (e) {
        emit(AuthFailure('Error cargando recordados $e'));
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
