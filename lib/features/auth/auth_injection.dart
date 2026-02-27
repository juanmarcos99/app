import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/share/data/repositories_impl/patient_repository_impl.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/services/storage_services.dart';

final sl = GetIt.instance;

void initAuthDependencies() {

  // Datasources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl<Database>()),
  );
  sl.registerLazySingleton<PatientLocalDataSources>(
    () => PatientLocalDataSourcesImpl(sl<Database>()),
  );
  sl.registerLazySingleton<RememberLocalDataSource>(
    () => RememberLocalDataSourceImpl(sl<StorageService>()),
  );

  // Repositorios
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserLocalDataSource>()),
  );
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(sl<PatientLocalDataSources>()),
  );
  sl.registerLazySingleton<RememberRepository>(
    () => RememberRepositoryImpl(sl<RememberLocalDataSource>()),
  );

  // Casos de uso
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<UserRepository>()),
  );
  sl.registerLazySingleton<RegisterPatient>(
    () => RegisterPatient(sl<PatientRepository>()),
  );
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl<UserRepository>()));
  sl.registerLazySingleton<ChangePassword>(
    () => ChangePassword(sl<UserRepository>()),
  );

  sl.registerLazySingleton<ClearRememberedUsers>(
    () => ClearRememberedUsers(sl<RememberRepository>()),
  );

  sl.registerLazySingleton<RememberUser>(() => RememberUser(sl<RememberRepository>()));

  sl.registerLazySingleton<DeleteUserRemembered>(
    () => DeleteUserRemembered(sl<RememberRepository>()),
  );

  sl.registerLazySingleton<GetRememberedUsers>(
    () => GetRememberedUsers(sl<RememberRepository>()),
  );

  sl.registerLazySingleton<GetPassword>(
    () => GetPassword(sl<RememberRepository>()),
  );
  sl.registerLazySingleton<SavePassword>(
    () => SavePassword(sl<RememberRepository>()),
  );

  

  // Bloc
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      sl<RegisterUser>(),
      sl<LoginUser>(),
      sl<RegisterPatient>(),
      sl<ChangePassword>(),
      sl<RememberUser>(),
      sl<SavePassword>(),
      sl<GetRememberedUsers>(),
      sl<GetPassword>()
    ),
  );
}
