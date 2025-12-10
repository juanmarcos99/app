import 'package:app/features/auth/domain/auth_domain.dart';

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

//eventos para el registro
class LoginUserEvent extends AuthEvent {
  final String username;
  final String password;
  LoginUserEvent(this.username, this.password);
}
