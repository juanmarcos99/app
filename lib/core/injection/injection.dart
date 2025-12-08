import 'package:app/features/auth/data/repositories_impl/patient_repository_impl.dart';
import 'package:app/features/auth/domain/use_cases/register_patient.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

//base de datos
import '../database/app_database.dart';

// Barriles de auth
import '../../features/auth/data/auth_data.dart';
import '../../features/auth/domain/auth_domain.dart';
import '../../features/auth/ui/auth_ui.dart';

final sl = GetIt.instance; // service locator

Future<void> init() async {
  // Base de datos
  final db = await AppDatabase.getDatabase();
  sl.registerLazySingleton<Database>(() => db);

  // Datasource
sl.registerLazySingleton<UserLocalDataSource>(
  () => UserLocalDataSourceImpl(sl<Database>()),
);
sl.registerLazySingleton<PatientLocalDataSources>(
  () => PatientLocalDataSourcesImpl(sl<Database>()),
);

// Repositorio
sl.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(sl<UserLocalDataSource>()),
);
sl.registerLazySingleton<PatientRepository>(
  () => PatientRepositoryImpl(sl<PatientLocalDataSources>()),
);
  // Caso de uso
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<UserRepository>()),
  );
  sl.registerLazySingleton<RegisterPatient>(
    () => RegisterPatient(sl<PatientRepository>()),
  );
 

  // Bloc
  sl.registerFactory<AuthBloc>(
  () => AuthBloc(sl<RegisterUser>(), sl<RegisterPatient>()),
);
}
