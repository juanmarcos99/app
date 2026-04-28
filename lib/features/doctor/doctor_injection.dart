import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/datasources/doctor_local_data_source.dart';
import 'data/datasources/doctor_remote_data_source.dart';
import 'data/repositories_impl/doctor_repository_impl.dart';
import 'domain/repositories/doctor_repository.dart';
import 'domain/use_cases/get_linked_patients_usecase.dart';
import 'ui/bloc/doctor_bloc.dart';
import 'ui/bloc/scan_patient_bloc.dart';

final sl = GetIt.instance;

void initDoctorDependencies() {
  // Data sources
  sl.registerLazySingleton<DoctorLocalDataSource>(
    () => DoctorLocalDataSourceImpl(sl<Database>()),
  );
  sl.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // Repository
  sl.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLinkedPatientsUseCase(sl()));

  // Bloc
  sl.registerFactory(() => DoctorBloc(getLinkedPatientsUseCase: sl()));
  sl.registerFactory(() => ScanPatientBloc(doctorRepository: sl()));
}
