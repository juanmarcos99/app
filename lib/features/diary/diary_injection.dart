import 'package:app/features/diary/domain/use_cases/update_adverse_event.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'diary.dart';

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

  // 🔥 Medication datasource
  sldiary.registerLazySingleton<MedicationLocalDataSource>(
    () => MedicationLocalDataSourceImpl(sldiary<Database>()),
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
    () => CrisisRepositoryImpl(sldiary<CrisisLocalDataSource>()),
  );

  sldiary.registerLazySingleton<AdverseEventRepository>(
    () => AdverseEventRepositoryImpl(sldiary<AdverseEventLocalDataSource>()),
  );

  sldiary.registerLazySingleton<PdfRepository>(
    () => PdfRepositoryImpl(sldiary<PdfGeneratorService>()),
  );

  // 🔥 Medication repository
  sldiary.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(sldiary<MedicationLocalDataSource>()),
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

  // 🔥 MedicationBloc
  sldiary.registerFactory<MedicationBloc>(
    () => MedicationBloc(
      addMedication: sldiary<AddMedication>(),
      updateMedication: sldiary<UpdateMedication>(),
      deleteMedication: sldiary<DeleteMedication>(),
      getMedicationsByUser: sldiary<GetMedicationsByUser>(),
    ),
  );
}
