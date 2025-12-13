import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    _db = await openDatabase(
      join(await getDatabasesPath(), 'app.db'),
      version: 1,
      onCreate: (db, version) async {
        // Tabla de usuarios
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            lastName TEXT NOT NULL,
            email TEXT NOT NULL,
            phoneNumber TEXT NOT NULL, 
            userName TEXT NOT NULL UNIQUE,           
            passwordHash TEXT NOT NULL,
            role TEXT NOT NULL
          )
        ''');

        // Tabla de pacientes
        await db.execute('''
          CREATE TABLE patients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            caregiverNumber TEXT NOT NULL,
            caregiverEmail TEXT NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // Tabla de crisis (registro principal)
        await db.execute('''
          CREATE TABLE crisis (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fechaRegistro TEXT NOT NULL,   -- fecha en que se registró
            fechaCrisis TEXT NOT NULL,     -- día en que ocurrió la crisis
            usuarioId INTEGER NOT NULL,    -- usuario que registró la crisis
            FOREIGN KEY (usuarioId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // Tabla de detalles de crisis (episodios dentro de una crisis)
        await db.execute('''
          CREATE TABLE crisis_detalle (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            crisisId INTEGER NOT NULL,     -- relación con crisis
            horario TEXT NOT NULL,         -- intervalo horario
            tipo TEXT NOT NULL,            -- tipo de crisis
            cantidad INTEGER NOT NULL,     -- número de crisis en ese horario
            FOREIGN KEY (crisisId) REFERENCES crisis(id) ON DELETE CASCADE
          )
        ''');
      },
    );

    return _db!;
  }
}
