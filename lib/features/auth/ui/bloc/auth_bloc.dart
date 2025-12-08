import 'package:app/features/auth/domain/use_cases/register_patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/domain/auth_domain.dart';
import '../auth_ui.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final RegisterPatient registerPatient;

  int? _userId; // userId generado por la BD
  User? user; // usuario ya con id

  AuthBloc(this.registerUser, this.registerPatient) : super(AuthInitial()) {
    // Se registra el usuario
    on<RegisterUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        _userId = await registerUser(event.user);
        user = event.user.copyWith(id: _userId);

        if (user!.role == 'patient') {
          emit(UserRegistrated(user!)); // estado intermedio
        } else {
          emit(UserFullyRegistrated(user!)); // flujo completo para no-paciente
        }
      } catch (e) {
        emit(AuthFailure('Error al registrar usuario: $e'));
      }
    });

    //Se registra el paciente
    on<RegisterPatientEvent>((event, emit) async {
      // Si por alguna razón llega antes de tener _userId, protegemos.
      if (_userId == null) {
        emit(AuthFailure('Aún no hay userId para registrar el paciente.'));
        return;
      }

      emit(AuthLoading());
      try {
        final patientWithId = event.patient.copyWith(userId: _userId);
        await registerPatient(patientWithId);
        emit(UserFullyRegistrated(user!)); // ahora sí, registro completo
      } catch (e) {
        emit(AuthFailure('Error al registrar paciente: $e'));
      }
    });
  }
}
