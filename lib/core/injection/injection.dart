import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

//base de datos
import '../database/app_database.dart';

// Barriles de auth
import '../../features/auth/data/auth_data.dart';
import '../../features/auth/domain/auth_domain.dart';

final sl = GetIt.instance; // service locator

Future<void> init() async {
  // Base de datos
  final db = await AppDatabase.getDatabase();
  sl.registerLazySingleton<Database>(() => db);

  // Datasource
  sl.registerLazySingleton<UserLocalDataSourceImpl>(
    () => UserLocalDataSourceImpl(sl<Database>()),
  );

  // Repositorio
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserLocalDataSourceImpl>()),
  );

  // Caso de uso
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<UserRepository>()),
  );

  // Bloc
  
}
