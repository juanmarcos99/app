import 'package:app/core/core.dart';
import 'package:app/core/share/data/datasources/remote_data_sourse/user_remote_data_source.dart';
import 'package:app/core/share/domain/use_cases/sync/get_pending_sync_tasks_use_case.dart';
import 'package:app/core/share/domain/use_cases/sync/mark_sync_task_as_error_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/share/data/repositories_impl/patient_repository_impl.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/core.dart';

final sl = GetIt.instance;

void initAuthDependencies() {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
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
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(Supabase.instance.client),
  );
  sl.registerLazySingleton<SyncQueueLocalDataSource>(
    () => SyncQueueLocalDataSourceImpl(sl<Database>()),
  );

  // Repositorios
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      sl<UserLocalDataSource>(),
      sl<UserRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(sl<PatientLocalDataSources>()),
  );
  sl.registerLazySingleton<RememberRepository>(
    () => RememberRepositoryImpl(sl<RememberLocalDataSource>()),
  );
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      localDataSource: sl<SyncQueueLocalDataSource>(),
      supabaseClient: sl<SupabaseClient>(),
    ),
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

  sl.registerLazySingleton<RememberUser>(
    () => RememberUser(sl<RememberRepository>()),
  );

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
  sl.registerLazySingleton<AddToSyncQueueUseCase>(
    () => AddToSyncQueueUseCase(sl<SyncRepository>()),
  );
  sl.registerLazySingleton<DeleteSyncTaskUseCase>(
    () => DeleteSyncTaskUseCase(sl<SyncRepository>()),
  );
  sl.registerLazySingleton<GetPendingSyncTasksUseCase>(
    () => GetPendingSyncTasksUseCase(sl<SyncRepository>()),
  );

  sl.registerLazySingleton<MarkSyncTaskAsErrorUseCase>(
    () => MarkSyncTaskAsErrorUseCase(sl<SyncRepository>()),
  );
  sl.registerLazySingleton<ProcessFullSyncQueueUseCase>(
    () => ProcessFullSyncQueueUseCase(sl<SyncRepository>()),
  );
  sl.registerLazySingleton<SyncFirstTaskUseCase>(
    () => SyncFirstTaskUseCase(sl<SyncRepository>()),
  );
  sl.registerLazySingleton<RegisterRemoteUser>(
    () => RegisterRemoteUser(sl<UserRepository>()),
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
      sl<GetPassword>(),
      sl<AddToSyncQueueUseCase>(),
      sl<RegisterRemoteUser>(),
    ),
  );
}
