import 'package:app/features/auth/domain/auth_domain.dart';

//estado abstracto del cual heredan los demas
abstract class AuthState {}

//estados comunes
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

//estados para el registro
class UserNameExist extends AuthState {}
class UserRegistrated extends AuthState {
  final User user;
  UserRegistrated(this.user);
}
class PatientRegistrated extends AuthState {
  final Patient patient;
  PatientRegistrated(this.patient);
}
class UserFullyRegistrated extends AuthState {
  final User user;
  UserFullyRegistrated(this.user);
}
//estados para el login
class UserLoggedIn extends AuthState {
  final User user;
  UserLoggedIn(this.user);
}
