import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/core/share/domain/use_cases/remember/delete_user_remembered.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/diary/domain/use_cases/user/update_remote_user_use_case.dart';
import 'profile_doctor_event_state.dart';

class ProfileDoctorBloc
    extends Bloc<ProfileDoctorEvent, ProfileDoctorState> {
  final UpdateUser updateUser;
  final UpdateRemoteUser updateRemoteUser;
  final DeleteUser deleteUser;
  final DeleteRemoteUser deleteRemoteUser;
  final DeleteUserRemembered deleteUserRemembered;
  final CheckUserExistence checkUserExistence;
  final UpdateUserRemembered updateUserRemembered;
  final AddToSyncQueueUseCase addToSyncQueueUseCase;
  final GetPendingSyncTasksUseCase getPendingSyncTasksUseCase;

  ProfileDoctorBloc({
    required this.updateUser,
    required this.updateRemoteUser,
    required this.deleteUser,
    required this.deleteRemoteUser,
    required this.deleteUserRemembered,
    required this.checkUserExistence,
    required this.updateUserRemembered,
    required this.addToSyncQueueUseCase,
    required this.getPendingSyncTasksUseCase,
  }) : super(ProfileDoctorInitial()) {
    on<LoadProfileDoctorData>(_onLoad);
    on<UpdateProfileDoctorData>(_onUpdate);
    on<DeleteProfileDoctorData>(_onDelete);
  }

  Future<void> _onLoad(
    LoadProfileDoctorData event,
    Emitter<ProfileDoctorState> emit,
  ) async {
    emit(ProfileDoctorLoading());
    emit(ProfileDoctorLoaded(user: event.user));
  }

  Future<void> _onUpdate(
    UpdateProfileDoctorData event,
    Emitter<ProfileDoctorState> emit,
  ) async {
    emit(ProfileDoctorLoading());
    try {
      // Check username uniqueness if changed
      if (event.userBeforeUpdate.userName != event.userUpdated.userName) {
        final exists = await checkUserExistence(event.userUpdated.userName);
        if (exists == -1) {
          emit(const ProfileDoctorError('El nombre de usuario ya existe'));
          return;
        }
      }

      // Save locally
      await updateUser(event.userUpdated);

      if (event.userBeforeUpdate.userName != event.userUpdated.userName) {
        await updateUserRemembered(
          event.userBeforeUpdate.userName,
          event.userUpdated.userName,
        );
      }

      // Notify success immediately
      emit(ProfileDoctorUpdated(user: event.userUpdated));

      // Try remote update
      try {
        final pending = await getPendingSyncTasksUseCase();
        if (pending.isNotEmpty) throw ServerException('Cola activa');
        await updateRemoteUser(event.userUpdated);
      } catch (e) {
        debugPrint('Fallo update remoto doctor, encolando: $e');
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
          },
        );
        try {
          await addToSyncQueueUseCase(task);
        } catch (qe) {
          debugPrint('Error guardando en cola: $qe');
        }
      }
    } catch (e) {
      emit(ProfileDoctorError('Error actualizando perfil: $e'));
    }
  }

  Future<void> _onDelete(
    DeleteProfileDoctorData event,
    Emitter<ProfileDoctorState> emit,
  ) async {
    emit(ProfileDoctorLoading());
    try {
      await deleteUser(event.user.id!);
      await deleteUserRemembered(event.user.userName);
      emit(ProfileDoctorDeleted());

      try {
        final pending = await getPendingSyncTasksUseCase();
        if (pending.isEmpty) {
          await deleteRemoteUser(event.user.id!);
        } else {
          throw ServerException('Cola de tareas pendiente');
        }
      } catch (e) {
        debugPrint('Fallo al borrar cuenta remotamente: $e');
        final task = SyncTaskModel(
          endpoint: 'users',
          userId: event.user.id!,
          method: 'DELETE',
          payload: {'id': event.user.id},
        );
        try {
          await addToSyncQueueUseCase(task);
        } catch (queueErr) {
          debugPrint('Error guardando tarea de borrado en cola: $queueErr');
        }
      }
    } catch (e) {
      if (e is LocalDataBaseException) {
        emit(ProfileDoctorError('Error local al eliminar: ${e.message}'));
      } else {
        emit(ProfileDoctorError('Error inesperado al eliminar: $e'));
      }
    }
  }
}
