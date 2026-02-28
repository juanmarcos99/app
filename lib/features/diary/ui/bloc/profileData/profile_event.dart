import 'package:app/features/auth/auth.dart';

abstract class ProfileEvent {}

class LoadProfileData extends ProfileEvent {
  final User user;

  LoadProfileData(this.user);
}

class UpdateProfileData extends ProfileEvent {
  final User userBeforeUpdate;
  final User userUpdated;

  UpdateProfileData(this.userBeforeUpdate, this.userUpdated);
}

class DeleteProfile extends ProfileEvent {
  final User user;
  DeleteProfile(this.user);
}
