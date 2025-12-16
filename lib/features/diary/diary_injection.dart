import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'diary.dart';

final sldiary = GetIt.instance;

void initDiaryDependencies() {
  // Datasource
  sldiary.registerLazySingleton<CrisisLocalDataSource>(
    () => CrisisLocalDataSourceImpl(sldiary<Database>()),
  );

  // Repositorio
  sldiary.registerLazySingleton<CrisisRepository>(
    () => CrisisRepositoryImpl(sldiary<CrisisLocalDataSource>()),
  );

  // Casos de uso
  sldiary.registerLazySingleton<AddCrisis>(
    () => AddCrisis(sldiary<CrisisRepository>()),
  );

  // Bloc
  sldiary.registerLazySingleton<DiaryBloc>(
    () => DiaryBloc(sldiary<AddCrisis>()),
  );
}
