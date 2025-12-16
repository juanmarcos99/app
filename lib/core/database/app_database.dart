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

        // Tabla de crisis
        await db.execute('''
          CREATE TABLE crisis (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            registeredDate TEXT NOT NULL,   -- ISO 8601 completo
            crisisDate TEXT NOT NULL,       -- YYYY-MM-DD
            timeRange TEXT NOT NULL,        -- ej. "6:00 am - 10:00 am"
            quantity INTEGER NOT NULL,
            type TEXT NOT NULL,             -- ej. "Focal aware"
            userId INTEGER NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      },
    );

    return _db!;
  }
}
