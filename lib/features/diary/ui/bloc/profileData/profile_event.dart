import 'package:app/features/auth/auth.dart';

abstract class ProfileEvent {}

class LoadProfileData extends ProfileEvent {
  final User user;

  LoadProfileData(this.user);
}

class UpdateProfileData extends ProfileEvent {
  final User updatedUser;

  UpdateProfileData(this.updatedUser);
}

class DeleteProfile extends ProfileEvent {
  final int userId;
  DeleteProfile(this.userId);
}
