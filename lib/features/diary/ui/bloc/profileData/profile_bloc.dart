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
      // 1. Validar si el nombre de usuario ya existe (solo si se intentó cambiar)
      if (event.userBeforeUpdate.userName != event.userUpdated.userName) {
        final existence = await checkUserExistence(event.userUpdated.userName);
        if (existence == -1) {
          emit(ProfileError("El nombre de usuario ya existe"));
          return;
        }
      }

      // 2. Actualizar datos básicos del usuario
      await updateUser(event.userUpdated);

      // 3. Actualizar el nombre de usuario recordado si cambió
      if (event.userBeforeUpdate.userName != event.userUpdated.userName) {
        await updateUserRemembered(
          event.userBeforeUpdate.userName,
          event.userUpdated.userName,
        );
      }

      // 4. Manejo de la actualización del Paciente
      Patient? finalPatient = event.patientUpdated;

      if (finalPatient != null) {
        // Si el objeto que viene de la UI no tiene el ID (o es 0), lo rescatamos de la BD
        if (finalPatient.id == null || finalPatient.id == 0) {
          final dbPatient = await getPatientByUserId(finalPatient.userId);
          if (dbPatient != null) {
            // IMPORTANTE: Reasignamos finalPatient con el nuevo objeto que SÍ tiene el ID
            finalPatient = finalPatient.copyWith(id: dbPatient.id);
          }
        }
        // Ahora enviamos el objeto que garantizamos que tiene el ID correcto
        await updatePatient(finalPatient);
      }

      // 5. Emitir el estado de éxito con los datos actualizados
      emit(ProfileUpdated(user: event.userUpdated, patient: finalPatient));
    } catch (e) {
      emit(ProfileError("Error actualizando usuario: $e"));
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

      await deleteRemoteUser(event.user.id!);

      emit(ProfileDeleted());
    } on LocalDataBaseException catch (e) {
      emit(ProfileError("Error local al eliminar: ${e.message}"));
    } on ServerException catch (e) {
      debugPrint("no ses elimino el user $e");
      final task = SyncTaskModel(
        endpoint: 'users',
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
