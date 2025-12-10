import 'package:app/features/auth/domain/use_cases/login_user.dart';
import 'package:app/features/auth/domain/use_cases/register_patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/domain/auth_domain.dart';
import '../auth_ui.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser; //caso de uso del registro de usuario
  final RegisterPatient registerPatient; //caso de uso del registro de paceinte
  final LoginUser loginUser; //caso de uso del login

  int? _userId; // userId generado por la BD
  User? user; // usuario ya con id

  AuthBloc(this.registerUser, this.loginUser, this.registerPatient)
    : super(AuthInitial()) {
    //------------------------------------------------------------------------
    //                        Blocs para el registro
    //------------------------------------------------------------------------
    // ------------------------Registro del usuario-------------------------
    on<RegisterUserEvent>((event, emit) async {
      emit(
        AuthLoading(),
      ); //Se emite el estado de carga mientras se ejecuta el registro
      try {
        _userId = await registerUser(
          event.user,
        ); //Se registra el usuario y devuleve un entero
        if (_userId == -2) {
          // Si el entero devuelto es -2 el usuario existe
          emit(
            UserNameExist(),
          ); // En ese caso se emite el estado de existe user
        } else {
          // si el usuario es paciente se emite usuario registrado sino usuario completamente registrado
          user = event.user.copyWith(
            id: _userId,
          ); // se transcribe el user con el id asignado a la BD
          if (user!.role == 'patient') {
            emit(
              UserRegistrated(user!),
            ); // el UserRegistrated es un estado intermedio
          } else {
            emit(
              UserFullyRegistrated(
                user!,
              ), // si se registra completamente el usuario significa q puede navegar a la siguiente pantalla
            ); // flujo completo para no-paciente
          }
        }
      } catch (e) {
        emit(AuthFailure('Error al registrar usuario: $e'));
      }
    });

    //---------------------Se registra el paciente------------------------
    on<RegisterPatientEvent>((event, emit) async {
      // Si por alguna razón llega antes de tener _userId, protegemos.
      if (_userId == null) {
        emit(AuthFailure('Aún no hay userId para registrar el paciente.'));
        return;
      }
      emit(AuthLoading()); //Se emite el estado de carga mientras se registra
      try {
        final patientWithId = event.patient.copyWith(
          userId: _userId,
        ); //transcribo el paceitne con el userId correspondiente a la relacion paciente con el user
        await registerPatient(patientWithId);
        emit(UserFullyRegistrated(user!)); // ahora sí, registro completo
      } catch (e) {
        emit(AuthFailure('Error al registrar paciente: $e'));
      }
    });

    //------------------------------------------------------------------------
    //                        Blocs para el login
    //------------------------------------------------------------------------
    on<LoginUserEvent>((event, emit) async {     
      try {
        final loggedUser = await loginUser(event.username, event.password);
        if (loggedUser != null) {
          emit(UserLoggedIn(loggedUser));
        } else {
          emit(AuthFailure('Credenciales inválidas.'));
        }
      } catch (e) {
        emit(AuthFailure('Error al iniciar sesión: $e'));
      }
    });
  }
}
