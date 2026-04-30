import 'package:equatable/equatable.dart';
import 'package:app/features/auth/auth.dart';

// ─── EVENTS ───────────────────────────────────────────────────────────────────
abstract class ProfileDoctorEvent extends Equatable {
  const ProfileDoctorEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileDoctorData extends ProfileDoctorEvent {
  final User user;
  const LoadProfileDoctorData(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateProfileDoctorData extends ProfileDoctorEvent {
  final User userBeforeUpdate;
  final User userUpdated;
  const UpdateProfileDoctorData(this.userBeforeUpdate, this.userUpdated);
  @override
  List<Object?> get props => [userBeforeUpdate, userUpdated];
}

class DeleteProfileDoctorData extends ProfileDoctorEvent {
  final User user;
  const DeleteProfileDoctorData(this.user);
  @override
  List<Object?> get props => [user];
}

// ─── STATES ───────────────────────────────────────────────────────────────────
abstract class ProfileDoctorState extends Equatable {
  const ProfileDoctorState();
  @override
  List<Object?> get props => [];
}

class ProfileDoctorInitial extends ProfileDoctorState {}

class ProfileDoctorLoading extends ProfileDoctorState {}

class ProfileDoctorLoaded extends ProfileDoctorState {
  final User user;
  const ProfileDoctorLoaded({required this.user});
  @override
  List<Object?> get props => [user];
}

class ProfileDoctorUpdated extends ProfileDoctorState {
  final User user;
  const ProfileDoctorUpdated({required this.user});
  @override
  List<Object?> get props => [user];
}

class ProfileDoctorError extends ProfileDoctorState {
  final String message;
  const ProfileDoctorError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileDoctorDeleted extends ProfileDoctorState {}
