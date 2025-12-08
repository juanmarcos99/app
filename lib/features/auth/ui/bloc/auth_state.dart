import 'package:app/features/auth/domain/auth_domain.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class PatientRegistrated extends AuthState {
  final Patient patient;
  PatientRegistrated(this.patient);
}

class UserRegistrated extends AuthState {
  final User user;
  UserRegistrated(this.user);
}
