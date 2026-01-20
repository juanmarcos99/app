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
        // ---------------------------------------------------------
        // USERS
        // ---------------------------------------------------------
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

        // ---------------------------------------------------------
        // PATIENTS
        // ---------------------------------------------------------
        await db.execute('''
          CREATE TABLE patients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            caregiverNumber TEXT NOT NULL,
            caregiverEmail TEXT NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // ---------------------------------------------------------
        // CRISIS
        // ---------------------------------------------------------
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

        // ---------------------------------------------------------
        // ADVERSE EVENTS
        // ---------------------------------------------------------
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
        // MEDICATIONS (camelCase + corregida)
        // ---------------------------------------------------------
        await db.execute('''
          CREATE TABLE medications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            notes TEXT,
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // ---------------------------------------------------------
        // SCHEDULES (camelCase + notificationId)
        // ---------------------------------------------------------
        await db.execute('''
          CREATE TABLE schedules (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicationId INTEGER NOT NULL,
            time TEXT NOT NULL,
            notificationId INTEGER NOT NULL,
            FOREIGN KEY (medicationId) REFERENCES medications(id) ON DELETE CASCADE
          )
        ''');
      },
    );

    return _db!;
  }
}
