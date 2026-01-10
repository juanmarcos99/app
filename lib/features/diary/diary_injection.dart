import 'package:app/features/diary/domain/use_cases/update_adverse_event.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'diary.dart';

final sldiary = GetIt.instance;

void initDiaryDependencies() {
  // Datasource
  sldiary.registerLazySingleton<CrisisLocalDataSource>(
    () => CrisisLocalDataSourceImpl(sldiary<Database>()),
  );
  sldiary.registerLazySingleton<AdverseEventLocalDataSource>(
    () => AdverseEventLocalDataSourceImpl(sldiary<Database>()),
  );

  //SERVICEs
  sldiary.registerLazySingleton<PdfGeneratorService>(
    () => PdfGeneratorService(),
  );

  // Repositorio
  sldiary.registerLazySingleton<CrisisRepository>(
    () => CrisisRepositoryImpl(sldiary<CrisisLocalDataSource>()),
  );
  sldiary.registerLazySingleton<AdverseEventRepository>(
    () => AdverseEventRepositoryImpl(sldiary<AdverseEventLocalDataSource>()),
  );

  sldiary.registerLazySingleton<PdfRepository>(
    () => PdfRepositoryImpl(sldiary<PdfGeneratorService>()),
  );

  // Casos de uso
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

  // Bloc
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
}
