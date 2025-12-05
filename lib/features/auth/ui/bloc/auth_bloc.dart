import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:app/features/auth/domain/auth_domain.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;

  AuthBloc(this.registerUser) : super(AuthInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerUser(event.user); //usa el caso de uso
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure('Error al registrar usuario: $e'));
      }
    });
  }
}
