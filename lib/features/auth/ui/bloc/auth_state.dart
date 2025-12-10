import 'package:equatable/equatable.dart';
import 'package:app/features/auth/domain/auth_domain.dart';

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
