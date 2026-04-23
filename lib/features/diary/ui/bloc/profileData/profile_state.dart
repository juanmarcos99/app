import 'package:app/features/auth/auth.dart';

import '../../../../../core/core.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final Patient? patient;

  ProfileLoaded({required this.user, this.patient});
}

class ProfileUpdated extends ProfileState {
  final User user;
  final Patient? patient;

  ProfileUpdated({required this.user, this.patient});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileDeleted extends ProfileState {}

//estado para registrar tareas pendientes de sincronización
class SyncSuccess extends AuthState {
  final String mesage;
  const SyncSuccess(this.mesage);
}
class SyncError extends AuthState {
  final String error;
  const SyncError(this.error);
}

class SyncQueueadedd extends AuthState {
  final List<SyncTaskModel> tasks;
  const SyncQueueadedd(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

//estado para subida a base de datos remota 
class RemoteError extends AuthState {
  final String mesage;
  const RemoteError(this.mesage);
}