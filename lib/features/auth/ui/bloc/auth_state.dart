import 'package:equatable/equatable.dart';
import 'package:app/features/auth/auth.dart';
import '../../../../core/core.dart';

//estado abstracto del cual heredan los demas
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

//estados comunes
class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//estados para el registro
class UserNameExist extends AuthState {
  const UserNameExist();
}

class UserRegistrated extends AuthState {
  final User user;
  const UserRegistrated(this.user);

  @override
  List<Object?> get props => [user];
}

class PatientRegistrated extends AuthState {
  final Patient patient;
  const PatientRegistrated(this.patient);

  @override
  List<Object?> get props => [patient];
}

class UserFullyRegistrated extends AuthState {
  final User user;
  const UserFullyRegistrated(this.user);

  @override
  List<Object?> get props => [user];
}

//estados para el login
class UserLoggedIn extends AuthState {
  final User user;
  const UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailureLogin extends AuthState {
  final String message;
  const AuthFailureLogin(this.message);

  @override
  List<Object?> get props => [message];
}

//estados para cambio de contraseña
class UserPasswordChanged extends AuthState {
  const UserPasswordChanged();
}

//estado para usuarios recordados
class RememberUsersLoaded extends AuthState {
  final List<String> users;
  const RememberUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class PasswordLoaded extends AuthState {
  final String password;

  const PasswordLoaded(this.password);

  @override
  List<Object?> get props => [password];
}

//estado para registrar tareas pendientes de sincronización
class SyncSuccess extends AuthState {
  final String mesage;
  const SyncSuccess(this.mesage);
}
class SyncError extends AuthState {
  final String message;
  const SyncError(this.message);
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

