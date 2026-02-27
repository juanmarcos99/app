import 'package:app/features/auth/auth.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final Patient? patient;

  ProfileLoaded({required this.user, this.patient});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
