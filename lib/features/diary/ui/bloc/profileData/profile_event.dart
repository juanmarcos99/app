import 'package:app/features/auth/auth.dart';

abstract class ProfileEvent {}

class LoadProfileData extends ProfileEvent {
  final User user;

  LoadProfileData(this.user);
}

class UpdateProfileData extends ProfileEvent {
  final User userBeforeUpdate;
  final User userUpdated;
  final Patient? patientUpdated;

  UpdateProfileData(this.userBeforeUpdate, this.userUpdated, this.patientUpdated);
}

class DeleteProfile extends ProfileEvent {
  final User user;
  DeleteProfile(this.user);
}
