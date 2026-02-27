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
}
