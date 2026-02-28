import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/diary.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUser updateUser;
  final DeleteUser deleteUser;
  final UpdatePatient updatePatient;
  final GetPatientByUserId getPatientByUserId;

  ProfileBloc({
    required this.updateUser,
    required this.deleteUser,
    required this.updatePatient,
    required this.getPatientByUserId,
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
      emit(ProfileLoaded(user: event.user, patient: patient));
    } catch (e) {
      emit(ProfileError("Error cargando perfil: $e"));
    }
  }

  Future<void> _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final patient = await getPatientByUserId(event.updatedUser.id!);

      // Actualizamos usuario
      await updateUser(event.updatedUser);

      // Si es paciente, actualizamos también
      if (patient != null) {
        await updatePatient(patient);
      }

      // Emitimos estado actualizado
      emit(ProfileUpdated(user: event.updatedUser, patient: patient));
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
      await deleteUser(event.userId);
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError("Error eliminando usuario: $e"));
    }
  }
}
