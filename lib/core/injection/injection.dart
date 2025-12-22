import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';

final slCore = GetIt.instance;

Future<void> initCoreDependencies() async {
  // Base de datos (transversal)
  final db = await AppDatabase.getDatabase();
  slCore.registerLazySingleton<Database>(() => db);

  
}
