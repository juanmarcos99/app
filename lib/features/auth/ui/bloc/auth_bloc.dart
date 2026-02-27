import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser; //caso de uso del registro de usuario
  final RegisterPatient registerPatient; //caso de uso del registro de paceinte
  final LoginUser loginUser; //caso de uso del login
  final ChangePassword changePassword; //caso de uso de cambiar la contraseña
  final RememberUser saveUser; //caso de uso de guardar usuario en local
  final SavePassword savePassword; //caso de uso de guardar contraseña en local
  final GetRememberedUsers getRememberedUsers; // obtener usuarios recordados
  final GetPassword getPassword;

  int? _userId; // userId generado por la BD
  User? user; // usuario ya con id

  AuthBloc(
    this.registerUser,
    this.loginUser,
    this.registerPatient,
    this.changePassword,
    this.saveUser,
    this.savePassword,
    this.getRememberedUsers, 
    this.getPassword,
  ) : super(const AuthInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        _userId = await registerUser(
          event.user,
        ); //Se registra el usuario y devuleve un entero
        if (_userId == -2) {
          // Si el entero devuelto es -2 el usuario existe
          emit(
            const UserNameExist(),
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

    on<RegisterPatientEvent>((event, emit) async {
      if (_userId == null) {
        emit(
          const AuthFailure('Aún no hay userId para registrar el paciente.'),
        );
        return;
      }
      emit(const AuthLoading());
      try {
        final patientWithId = event.patient.copyWith(userId: _userId);
        await registerPatient(patientWithId);
        emit(UserFullyRegistrated(user!));
      } catch (e) {
        emit(AuthFailure('Error al registrar paciente: $e'));
      }
    });

    on<LoginUserEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        final loggedUser = await loginUser(event.username, event.password);
        if (loggedUser != null) {
          if (event.rememberMe) {
            await saveUser(event.username.toString());
            await savePassword(
              event.username.toString(),
              event.password.toString(),
            );
          }
          emit(UserLoggedIn(loggedUser));
        } else {
          emit(
            const AuthFailure(
              'Credenciales inválidas, por favor rectifiquelas',
            ),
          );
        }
      } catch (e) {
        emit(AuthFailure('Error al iniciar sesión: $e'));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        //verificamos si la contraseña y el usuario estan bien
        final loggedUser = await loginUser(
          event.username,
          event.currentPassword,
        );
        if (loggedUser == null) {
          emit(AuthFailure('Credenciales inválidas, por favor rectifiquelas'));
        } else {
          await changePassword(event.username, event.newPassword);
          emit(const UserPasswordChanged());
        }
      } catch (e) {
        emit(AuthFailure('Error al cambiar contraseña: $e'));
      }
    });

    on<LoadRememberedUsersEvent>((event, emit) async {
      emit(const AuthLoading());

      try {
        final users = await getRememberedUsers();
        emit(RememberUsersLoaded(users));
      } catch (e) {
        emit(AuthFailure('Error al cargar usuarios recordados: $e'));
      }
    });

    on<LoadPasswordEvent>((event, emit) async {
      emit(const AuthLoading());

      try {
        // Aquí llamas a tu repositorio o servicio que obtiene la contraseña
        final password = await getPassword(event.username);

        emit(PasswordLoaded(password!));
        
      } catch (e) {
        emit(AuthFailure('Error al cargar contraseña: $e'));
        
      }
    });
  }
}
