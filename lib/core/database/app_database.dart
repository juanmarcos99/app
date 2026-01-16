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
            registeredDate TEXT NOT NULL,
            crisisDate TEXT NOT NULL,
            timeRange TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            type TEXT NOT NULL,
            userId INTEGER NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // Tabla de eventos adversos
        await db.execute('''
          CREATE TABLE adverse_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            registeredDate TEXT NOT NULL,
            eventDate TEXT NOT NULL,
            description TEXT NOT NULL,
            userId INTEGER NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // ---------------------------------------------------------
        // 🔥 TABLA: medicamentos (CORREGIDA)
        // ---------------------------------------------------------
        await db.execute('''
          CREATE TABLE medicamentos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            notes TEXT,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // ---------------------------------------------------------
        // 🔥 TABLA: horarios (CORREGIDA)
        // ---------------------------------------------------------
        await db.execute('''
          CREATE TABLE horarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicationId INTEGER NOT NULL,
            time TEXT NOT NULL,
            FOREIGN KEY (medicationId) REFERENCES medicamentos(id) ON DELETE CASCADE
          )
        ''');
      },
    );

    return _db!;
  }
}
