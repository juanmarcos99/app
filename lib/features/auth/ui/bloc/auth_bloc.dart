import 'package:app/features/auth/domain/use_cases/register_patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/domain/auth_domain.dart';
import '../auth_ui.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final RegisterPatient registerPatient;

  AuthBloc(this.registerUser, this.registerPatient) : super(AuthInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerUser(event.user); //usa el caso de uso
        emit(UserRegistrated(event.user));
      } catch (e) {
        emit(AuthFailure('Error al registrar usuario: $e'));
      }
    });
  }
}
