import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'core.dart';

final sl = GetIt.instance;

Future<void> initCoreDependencies() async {
  // Base de datos 
  final db = await AppDatabase.getDatabase();
  sl.registerLazySingleton<Database>(() => db);
  sl.registerLazySingleton<StorageService>(() => StorageService());
  
  
}
