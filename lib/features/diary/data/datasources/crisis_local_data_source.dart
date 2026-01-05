import 'package:sqflite/sqflite.dart';
import '../../diary.dart';

abstract class CrisisLocalDataSource {
  Future<int> addCrisis(CrisisModel crisis);
  Future<List<CrisisModel>> getAllCrisisByUser(int userId);
  Future<List<CrisisModel>> getCrisisByDateAndUser(DateTime date, int userId);
  Future<int> deleteCrisis(int id);
  Future<int> updateCrisis(CrisisModel crisis);
  Future<List<DateTime>> getCrisisDaysByUser(int userId);
  Future<List<CrisisModel>> getCrisisByMonthAndYear(
    int month,
    int year,
    int userId,
  );
}

// permite cambiar de DB sin que se afecte la app
class CrisisLocalDataSourceImpl implements CrisisLocalDataSource {
  final Database db;

  CrisisLocalDataSourceImpl(this.db);

  @override
  Future<int> addCrisis(CrisisModel crisis) async {
    try {
      return await db.insert('crisis', crisis.toMap());
    } on DatabaseException {
      // Manejo de errores de base de datos
      return -1;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<List<CrisisModel>> getAllCrisisByUser(int userId) async {
    final result = await db.query(
      'crisis',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => CrisisModel.fromMap(map)).toList();
  }

  //para las tarjetas
  @override
  Future<List<CrisisModel>> getCrisisByDateAndUser(
    DateTime date,
    int userId,
  ) async {
    // Normalizamos la fecha a YYYY-MM-DD
    final normalizedDay = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T').first;

    final result = await db.query(
      'crisis',
      where: 'crisisDate = ? AND userId = ?',
      whereArgs: [normalizedDay, userId],
      orderBy: 'registeredDate DESC',
    );
    return result.map((map) => CrisisModel.fromMap(map)).toList();
  }

  //para mostrar los dias con crisis en el calendario
  @override
  Future<List<DateTime>> getCrisisDaysByUser(int userId) async {
    final result = await db.rawQuery(
      'SELECT DISTINCT crisisDate FROM crisis WHERE userId = ? ORDER BY crisisDate DESC',
      [userId],
    );

    return result
        .map((row) => DateTime.parse(row['crisisDate'] as String))
        .map((d) => DateTime(d.year, d.month, d.day)) // normalizamos
        .toList();
  }

  @override
  Future<int> deleteCrisis(int id) async {
    return await db.delete('crisis', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateCrisis(CrisisModel crisis) async {
    return await db.update(
      'crisis',
      crisis.toMap(),
      where: 'id = ?',
      whereArgs: [crisis.id],
    );
  }

  @override
  Future<List<CrisisModel>> getCrisisByMonthAndYear(
    int month,
    int year,
    int userId,
  ) async {
    final monthStr = month.toString().padLeft(2, '0');
    final yearStr = year.toString();
    final result = await db.rawQuery(
      ''' SELECT * FROM crisis 
      WHERE strftime('%m', crisisDate) = ? 
      AND strftime('%Y', crisisDate) = ? 
      AND userId = ? 
      ORDER BY crisisDate DESC ''',
      [monthStr, yearStr, userId],
    );
    return result.map((map) => CrisisModel.fromMap(map)).toList();
  }
}
