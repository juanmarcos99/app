import 'package:app/features/auth/domain/auth_domain.dart';

abstract class AuthEvent {}

class RegisterUserEvent extends AuthEvent {
  final User user;

  RegisterUserEvent(this.user);
}
