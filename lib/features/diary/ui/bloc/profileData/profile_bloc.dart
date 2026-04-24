import 'package:app/features/diary/domain/use_cases/user/update_remote_user_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/core.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUser updateUser;
  final DeleteUser deleteUser;
  final UpdatePatient updatePatient;
  final GetPatientByUserId getPatientByUserId;
  final DeleteUserRemembered deleteUserRemembered;
  final CheckUserExistence checkUserExistence;
  final UpdateUserRemembered updateUserRemembered;
  final AddToSyncQueueUseCase addToSyncQueueUseCase;
  final DeleteRemoteUser deleteRemoteUser;
  final GetPendingSyncTasksUseCase getPendingSyncTasksUseCase;
  final UpdateRemoteUser updateRemoteUser;

  ProfileBloc({
    required this.updateUser,
    required this.deleteUser,
    required this.updatePatient,
    required this.getPatientByUserId,
    required this.deleteUserRemembered,
    required this.checkUserExistence,
    required this.updateUserRemembered,
    required this.addToSyncQueueUseCase,
    required this.deleteRemoteUser,
    required this.getPendingSyncTasksUseCase,
    required this.updateRemoteUser,
  }) : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<UpdateProfileData>(_onUpdateProfileData);
    on<DeleteProfile>(_onDeleteProfile);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final patient = await getPatientByUserId(event.user.id!);
      if (patient != null) {
        emit(ProfileLoaded(user: event.user, patient: patient));
      } else {
        emit(ProfileLoaded(user: event.user, patient: null));
      }
    } catch (e) {
      debugPrint("Error cargando perfil: $e");
      emit(ProfileError("Error cargando perfil: $e"));
    }
  }

  Future<void> _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // 1. Lógica de validación de usuario (Igual que la tenías)
      if (event.userBeforeUpdate.userName != event.userUpdated.userName) {
        final existence = await checkUserExistence(event.userUpdated.userName);
        if (existence == -1) {
          emit(ProfileError("El nombre de usuario ya existe"));
          return;
        }
      }

      // 2. ACTUALIZACIÓN LOCAL (Prioridad máxima)
      await updateUser(event.userUpdated);

      if (event.userBeforeUpdate.userName != event.userUpdated.userName) {
        await updateUserRemembered(
          event.userBeforeUpdate.userName,
          event.userUpdated.userName,
        );
      }

      Patient? finalPatient = event.patientUpdated;
      if (finalPatient != null) {
        if (finalPatient.id == null || finalPatient.id == 0) {
          final dbPatient = await getPatientByUserId(finalPatient.userId);
          if (dbPatient != null) {
            finalPatient = finalPatient.copyWith(id: dbPatient.id);
          }
        }
        await updatePatient(finalPatient);
      }

      // Éxito local: Informamos a la UI de inmediato
      emit(ProfileUpdated(user: event.userUpdated, patient: finalPatient));

      // 3. INTENTO DE ACTUALIZACIÓN REMOTA (Aislado para evitar AuthFailure por red)
      try {
        final pendingTasks = await getPendingSyncTasksUseCase();

        // Si hay cola o falla el internet, saltamos al catch
        if (pendingTasks.isNotEmpty) {
          throw ServerException("Cola activa");
        }

        // Llamamos al nuevo método que creamos en el repositorio
        await updateRemoteUser(event.userUpdated);
      } catch (e) {
        // Fallo de red o servidor: Encolamos la tarea
        debugPrint("Fallo actualización remota, encolando: $e");

        final task = SyncTaskModel(
          endpoint: 'users',
          userId: event.userUpdated.id!,
          method: 'UPDATE',
          payload: {
            'id': event.userUpdated.id,
            'name': event.userUpdated.name,
            'lastName': event.userUpdated.lastName,
            'email': event.userUpdated.email,
            'phoneNumber': event.userUpdated.phoneNumber,
            'userName': event.userUpdated.userName,
            'role': event.userUpdated.role,
            // 'passwordHash': event.userUpdated.passwordHash, // Solo si es necesario aquí
          },
        );

        try {
          await addToSyncQueueUseCase(task);
        } catch (queueError) {
          debugPrint("Error crítico guardando en cola: $queueError");
          // No emitimos ProfileError aquí porque el cambio local ya fue exitoso
        }
      }
    } catch (e) {
      // Errores reales de la base de datos local
      emit(ProfileError("Error local actualizando perfil: $e"));
    }
  }

  Future<void> _onDeleteProfile(
    DeleteProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await deleteUser(event.user.id!);

      await deleteUserRemembered(event.user.userName);
      emit(ProfileDeleted());

      final pendingTasks = await getPendingSyncTasksUseCase();
      if (pendingTasks.isEmpty) {
        await deleteRemoteUser(event.user.id!);
      } else {
        throw ServerException(
          "no se puede subir a la nube, la cola tiene elementos pendientes",
        );
      }
    } on LocalDataBaseException catch (e) {
      emit(ProfileError("Error local al eliminar: ${e.message}"));
    } on ServerException catch (e) {
      debugPrint("no ses elimino el user $e");
      final task = SyncTaskModel(
        endpoint: 'users',
        userId: event.user.id!,
        method: 'DELETE',
        payload: {'id': event.user.id},
      );
      try {
        await addToSyncQueueUseCase(task);
      } catch (e) {
        emit(ProfileError("Error al guardar tarea de sincronización: $e"));
        return;
      }
      await deleteUserRemembered(event.user.userName);
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError("Error inesperado al eliminar: $e"));
    }
  }
}
