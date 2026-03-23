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

    ProfileBloc({
      required this.updateUser,
      required this.deleteUser,
      required this.updatePatient,
      required this.getPatientByUserId,
      required this.deleteUserRemembered,
      required this.checkUserExistence,
      required this.updateUserRemembered,
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
        final existence = await checkUserExistence(event.userUpdated.userName);
        if (event.userBeforeUpdate.userName != event.userUpdated.userName &&
            existence == -1) {
          emit(ProfileError("El nombre de usuario ya existe"));
        }
        if (event.userBeforeUpdate.userName != event.userUpdated.userName &&
            existence != -1) {
          // Actualizamos usuario
          await updateUser(event.userUpdated);
          await updateUserRemembered(
            event.userBeforeUpdate.userName,
            event.userUpdated.userName,
          );

          // Si es paciente, actualizamos también
          if (event.patientUpdated != null) {
            await updatePatient(event.patientUpdated!);
          }

          // Emitimos estado actualizado
          emit(
            ProfileUpdated(
              user: event.userUpdated,
              patient: event.patientUpdated,
            ),
          );
        } else {
          await updateUser(event.userUpdated);
          // Si es paciente, actualizamos también
          if (event.patientUpdated != null) {
            await updatePatient(event.patientUpdated!);
          }

          // Emitimos estado actualizado
          emit(
            ProfileUpdated(
              user: event.userUpdated,
              patient: event.patientUpdated,
            ),
          );
        }
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
        emit(ProfileDeleted());
      } catch (e) {
        emit(ProfileError("Error eliminando usuario: $e"));
      }
    }
  }
