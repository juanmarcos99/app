import 'package:get_it/get_it.dart';
import 'package:app/features/diary/domain/diary_domain.dart';
import 'package:app/features/diary/data/diary_data.dart';
import 'package:app/features/diary/ui/diary_ui.dart';
import 'package:sqflite/sqflite.dart';


final sl = GetIt.instance;

void initDiaryDependencies() {
  // Datasources
  sl.registerLazySingleton<CrisisLocalDataSource>(
    () => CrisisLocalDataSourceImpl(sl<Database>()),
  );
  sl.registerLazySingleton<CrisisDetalleLocalDataSource>(
    () => CrisisDetalleLocalDataSourceImpl(sl<Database>()),
  );

  // Repositorio
  sl.registerLazySingleton<CrisisRepository>(
    () => CrisisRepositoryImpl(
      crisisLocal: sl<CrisisLocalDataSource>(),
      detalleLocal: sl<CrisisDetalleLocalDataSource>(),
    ),
  );

  // Casos de uso
  sl.registerLazySingleton<RegisterCrisis>(
    () => RegisterCrisis(sl<CrisisRepository>()),
  );
  sl.registerLazySingleton<GetAllCrisisByUser>(
    () => GetAllCrisisByUser(sl<CrisisRepository>()),
  );

  // Bloc
  sl.registerFactory<DiaryBloc>(
    () => DiaryBloc(
      registerCrisis: sl<RegisterCrisis>(),
      getAllCrisisByUser: sl<GetAllCrisisByUser>(),
    ),
  );
}
