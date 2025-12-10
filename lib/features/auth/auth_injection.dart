import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'data/auth_data.dart';        
import 'data/repositories_impl/patient_repository_impl.dart';
import 'domain/auth_domain.dart';    // repositorios y entidades
import 'domain/use_cases/login_user.dart';
import 'domain/use_cases/register_patient.dart';
import 'ui/auth_ui.dart';           

final sl = GetIt.instance;

void initAuthDependencies() {
  // Datasources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl<Database>()),
  );
  sl.registerLazySingleton<PatientLocalDataSources>(
    () => PatientLocalDataSourcesImpl(sl<Database>()),
  );

  // Repositorios
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserLocalDataSource>()),
  );
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(sl<PatientLocalDataSources>()),
  );

  // Casos de uso
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<UserRepository>()),
  );
  sl.registerLazySingleton<RegisterPatient>(
    () => RegisterPatient(sl<PatientRepository>()),
  );
  sl.registerLazySingleton<LoginUser>(
    () => LoginUser(sl<UserRepository>()),
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(sl<RegisterUser>(), sl<LoginUser>(), sl<RegisterPatient>()),
  );
}
