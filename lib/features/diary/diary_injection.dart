import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/diary/domain/use_cases/user/update_remote_user_use_case.dart';
import 'package:app/core/share/data/datasources/remote_data_sourse/adverse_event_remote_data_source.dart';
import 'package:app/core/share/data/datasources/remote_data_sourse/crisis_remote_data_source.dart';
import 'package:app/features/diary/domain/use_cases/add_remote_adverse_event.dart';
import 'package:app/features/diary/domain/use_cases/get_remote_adverse_events_usecase.dart';
import 'package:app/features/diary/domain/use_cases/get_remote_crises_usecase.dart';
import 'package:app/features/diary/ui/bloc/patient_diary_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sldiary = GetIt.instance;

void initDiaryDependencies() {
  // -------------------------------------------------------------
  // DATASOURCES
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<CrisisLocalDataSource>(
    () => CrisisLocalDataSourceImpl(sldiary<Database>()),
  );

  sldiary.registerLazySingleton<AdverseEventLocalDataSource>(
    () => AdverseEventLocalDataSourceImpl(sldiary<Database>()),
  );

  sldiary.registerLazySingleton<CrisisRemoteDataSource>(
    () => CrisisRemoteDataSourceImpl(sldiary<SupabaseClient>()),
  );

  sldiary.registerLazySingleton<AdverseEventRemoteDataSource>(
    () => AdverseEventRemoteDataSourceImpl(sldiary<SupabaseClient>()),
  );

  // Medication datasource
  sldiary.registerLazySingleton<MedicationLocalDataSource>(
    () => MedicationLocalDataSourceImpl(sldiary<Database>()),
  );
  // appointment datasource
  sldiary.registerLazySingleton<AppointmentLocalDataSource>(
    () => AppointmentLocalDataSourceImpl(sldiary<Database>()),
  );

  // -------------------------------------------------------------
  // SERVICES
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<PdfGeneratorService>(
    () => PdfGeneratorService(),
  );

  // -------------------------------------------------------------
  // REPOSITORIES
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<CrisisRepository>(
    () => CrisisRepositoryImpl(
      sldiary<CrisisLocalDataSource>(),
      sldiary<CrisisRemoteDataSource>(),
    ),
  );

  sldiary.registerLazySingleton<AdverseEventRepository>(
    () => AdverseEventRepositoryImpl(
      sldiary<AdverseEventLocalDataSource>(),
      sldiary<AdverseEventRemoteDataSource>(),
    ),
  );

  sldiary.registerLazySingleton<PdfRepository>(
    () => PdfRepositoryImpl(sldiary<PdfGeneratorService>()),
  );

  sldiary.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(sldiary<MedicationLocalDataSource>()),
  );

  sldiary.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sldiary<AppointmentLocalDataSource>()),
  );

  // -------------------------------------------------------------
  // USE CASES — CRISIS
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<AddCrisis>(
    () => AddCrisis(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<GetCrisesByDay>(
    () => GetCrisesByDay(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<GetCrisesDays>(
    () => GetCrisesDays(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<DeleteCrisis>(
    () => DeleteCrisis(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<UpdateCrisis>(
    () => UpdateCrisis(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<GetLastCrisisDayByUser>(
    () => GetLastCrisisDayByUser(sldiary<CrisisRepository>()),
  );

  sldiary.registerLazySingleton<AddRemoteCrisis>(
    () => AddRemoteCrisis(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<GetRemoteCrisesByDayAndUserUseCase>(
    () => GetRemoteCrisesByDayAndUserUseCase(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<GetRemoteCrisesDaysByUserUseCase>(
    () => GetRemoteCrisesDaysByUserUseCase(sldiary<CrisisRepository>()),
  );


  // -------------------------------------------------------------
  // USE CASES — ADVERSE EVENTS
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<AddAdverseEvent>(
    () => AddAdverseEvent(sldiary<AdverseEventRepository>()),
  );
  sldiary.registerLazySingleton<GetAdverseAventByDayAndUser>(
    () => GetAdverseAventByDayAndUser(sldiary<AdverseEventRepository>()),
  );
  sldiary.registerLazySingleton<GetAdverseEventDaysByUser>(
    () => GetAdverseEventDaysByUser(sldiary<AdverseEventRepository>()),
  );
  sldiary.registerLazySingleton<DeleteAdverseEvent>(
    () => DeleteAdverseEvent(sldiary<AdverseEventRepository>()),
  );
  sldiary.registerLazySingleton<UpdateAdverseEvent>(
    () => UpdateAdverseEvent(sldiary<AdverseEventRepository>()),
  );

  sldiary.registerLazySingleton<AddRemoteAdverseEvent>(
    () => AddRemoteAdverseEvent(sldiary<AdverseEventRepository>()),
  );
  sldiary.registerLazySingleton<GetRemoteAdverseEventsByDayAndUserUseCase>(
    () => GetRemoteAdverseEventsByDayAndUserUseCase(sldiary<AdverseEventRepository>()),
  );
  sldiary.registerLazySingleton<GetRemoteAdverseEventsDaysByUserUseCase>(
    () => GetRemoteAdverseEventsDaysByUserUseCase(sldiary<AdverseEventRepository>()),
  );


  // -------------------------------------------------------------
  // USE CASES — PDF
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<GetCrisesByMonthAndYearUseCase>(
    () => GetCrisesByMonthAndYearUseCase(sldiary<CrisisRepository>()),
  );
  sldiary.registerLazySingleton<GetAdverseEventsByMonthAndYearUseCase>(
    () => GetAdverseEventsByMonthAndYearUseCase(
      sldiary<AdverseEventRepository>(),
    ),
  );
  sldiary.registerLazySingleton<GeneratePdfUseCase>(
    () => GeneratePdfUseCase(sldiary<PdfRepository>()),
  );

  // -------------------------------------------------------------
  // USE CASES — MEDICATION
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<AddMedication>(
    () => AddMedication(sldiary<MedicationRepository>()),
  );

  sldiary.registerLazySingleton<UpdateMedication>(
    () => UpdateMedication(sldiary<MedicationRepository>()),
  );

  sldiary.registerLazySingleton<DeleteMedication>(
    () => DeleteMedication(sldiary<MedicationRepository>()),
  );

  sldiary.registerLazySingleton<GetMedicationsByUser>(
    () => GetMedicationsByUser(sldiary<MedicationRepository>()),
  );

  sldiary.registerLazySingleton<GetMedicationById>(
    () => GetMedicationById(sldiary<MedicationRepository>()),
  );
  sldiary.registerLazySingleton<GetSchedulesWithNotificationIdsUseCase>(
    () =>
        GetSchedulesWithNotificationIdsUseCase(sldiary<MedicationRepository>()),
  );

  // -------------------------------------------------------------
  // USE CASES — profile data
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<UpdateUser>(
    () => UpdateUser(sldiary<UserRepository>()),
  );
  sldiary.registerLazySingleton<DeleteUser>(
    () => DeleteUser(sldiary<UserRepository>()),
  );
  sldiary.registerLazySingleton<UpdatePatient>(
    () => UpdatePatient(sldiary<PatientRepository>()),
  );
  sldiary.registerLazySingleton<GetPatientByUserId>(
    () => GetPatientByUserId(sldiary<PatientRepository>()),
  );
  sldiary.registerLazySingleton<CheckUserExistence>(
    () => CheckUserExistence(sldiary<UserRepository>()),
  );
  sldiary.registerLazySingleton<UpdateUserRemembered>(
    () => UpdateUserRemembered(sldiary<RememberRepository>()),
  );
 
  sldiary.registerLazySingleton<DeleteRemoteUser>(
    () => DeleteRemoteUser(sldiary<UserRepository>()),
  );
    sldiary.registerLazySingleton<UpdateRemoteUser>(
      () => UpdateRemoteUser(sldiary<UserRepository>()),
    );
  

  // -------------------------------------------------------------
  // USE CASES — profile data
  // -------------------------------------------------------------
  sldiary.registerLazySingleton<AddAppointment>(
    () => AddAppointment(sldiary<AppointmentRepository>()),
  );
  sldiary.registerLazySingleton<DeleteAppointment>(
    () => DeleteAppointment(sldiary<AppointmentRepository>()),
  );
  sldiary.registerLazySingleton<GetAppointmentById>(
    () => GetAppointmentById(sldiary<AppointmentRepository>()),
  );
  sldiary.registerLazySingleton<GetAppointmentsByUser>(
    () => GetAppointmentsByUser(sldiary<AppointmentRepository>()),
  );
 // -------------------------------------------------------------
  //use cases — sync
  // -------------------------------------------------------------
  // use cases — sync
// -------------------------------------------------------------

// 1. El que usa el HomeBloc (Este ya lo tenías bien)
sldiary.registerLazySingleton<GetPendingSyncTasksByUserIdUseCase>(
  () => GetPendingSyncTasksByUserIdUseCase(sldiary<SyncRepository>()),
);

// 2. El que usa el ProfileBloc (TE FALTABA ESTE NOMBRE EXACTO)


// 3. El que usa el ProfileBloc para encolar tareas (TE FALTABA REGISTRARLO)

// 4. Corrección del Process (usando sldiary en lugar de sl)
sldiary.registerLazySingleton<ProcessFullSyncQueueUseCase>(
  () => ProcessFullSyncQueueUseCase(sldiary<SyncRepository>()),
);


  // -------------------------------------------------------------
  // BLOCS
  // -------------------------------------------------------------
  sldiary.registerFactory<DiaryBloc>(
    () => DiaryBloc(
      sldiary<AddCrisis>(),
      sldiary<GetCrisesByDay>(),
      sldiary<GetCrisesDays>(),
      sldiary<AddAdverseEvent>(),
      sldiary<GetAdverseAventByDayAndUser>(),
      sldiary<GetAdverseEventDaysByUser>(),
      sldiary<DeleteCrisis>(),
      sldiary<DeleteAdverseEvent>(),
      sldiary<UpdateCrisis>(),
      sldiary<UpdateAdverseEvent>(),
      sldiary<AddRemoteCrisis>(),
      sldiary<AddRemoteAdverseEvent>(),
      sldiary<AddToSyncQueueUseCase>(),
      sldiary<GetPendingSyncTasksUseCase>(),
    ),
  );

  sldiary.registerFactory<PatientDiaryBloc>(
    () => PatientDiaryBloc(
      getCrisesByDayAndUser: sldiary<GetRemoteCrisesByDayAndUserUseCase>(),
      getCrisesDaysByUser: sldiary<GetRemoteCrisesDaysByUserUseCase>(),
      getAdverseEventByDayAndUser: sldiary<GetRemoteAdverseEventsByDayAndUserUseCase>(),
      getAdverseEventDaysByUser: sldiary<GetRemoteAdverseEventsDaysByUserUseCase>(),
    ),
  );

  sldiary.registerFactory<ReportBloc>(
    () => ReportBloc(
      getCrisesByMonthAndYearUseCase: sldiary<GetCrisesByMonthAndYearUseCase>(),
      getAdverseEventsByMonthAndYearUseCase:
          sldiary<GetAdverseEventsByMonthAndYearUseCase>(),
      generatePdfUseCase: sldiary<GeneratePdfUseCase>(),
    ),
  );

  //  MedicationBloc
  sldiary.registerFactory<MedicationBloc>(
    () => MedicationBloc(
      addMedication: sldiary<AddMedication>(),
      updateMedication: sldiary<UpdateMedication>(),
      deleteMedication: sldiary<DeleteMedication>(),
      getMedicationsByUser: sldiary<GetMedicationsByUser>(),
      getSchedulesWithNotificationIds:
          sldiary<GetSchedulesWithNotificationIdsUseCase>(),
    ),
  );
  //  profileBloc
  sldiary.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      updateUser: sldiary<UpdateUser>(),
      deleteUser: sldiary<DeleteUser>(),
      updatePatient: sldiary<UpdatePatient>(),
      getPatientByUserId: sldiary<GetPatientByUserId>(),
      deleteUserRemembered: sldiary<DeleteUserRemembered>(),
      checkUserExistence: sldiary<CheckUserExistence>(),
      updateUserRemembered: sldiary<UpdateUserRemembered>(),
      addToSyncQueueUseCase: sldiary<AddToSyncQueueUseCase>(),
      deleteRemoteUser: sldiary<DeleteRemoteUser>(),
      getPendingSyncTasksUseCase: sldiary<GetPendingSyncTasksUseCase>(),
      updateRemoteUser: sldiary<UpdateRemoteUser>(),
    ),
  );
  //  apointmentBloc
  sldiary.registerFactory<AppointmentBloc>(
    () => AppointmentBloc(
      addAppointment: sldiary<AddAppointment>(),
      deleteAppointment: sldiary<DeleteAppointment>(),
      getAppointmentById: sldiary<GetAppointmentById>(),
      getAppointmentsByUser: sldiary<GetAppointmentsByUser>(),
    ),
  );
 
  // -------------------------------------------------------------
  // BLOCS — HOME
  // -------------------------------------------------------------
  sldiary.registerFactory<HomeBloc>(
    () => HomeBloc(
      getPendingSyncTasksUserIdUseCase: sldiary<GetPendingSyncTasksByUserIdUseCase>(),
    ),
  );
 
}
