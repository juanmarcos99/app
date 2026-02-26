import 'package:app/features/auth/auth.dart';

//evento abstracto del cual heredan los demas
abstract class AuthEvent {}

//eventos para el registro
class RegisterUserEvent extends AuthEvent {
  final User user;
  RegisterUserEvent(this.user);
}

class RegisterPatientEvent extends AuthEvent {
  final Patient patient;
  RegisterPatientEvent(this.patient);
}

//eventos para el login
class LoginUserEvent extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;
  LoginUserEvent(this.username, this.password, this.rememberMe);
}

//cambio de contraseña
class ChangePasswordEvent extends AuthEvent {
  final String username;
  final String currentPassword;
  final String newPassword;
  ChangePasswordEvent(this.username, this.currentPassword, this.newPassword);
}

//evento para recordar credenciales
class LoadRememberedUsersEvent extends AuthEvent {}

class LoadPasswordEvent extends AuthEvent {
  final String username;
  LoadPasswordEvent(this.username);
}
