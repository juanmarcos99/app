import 'package:sqflite/sqflite.dart';
import '../../diary.dart';

abstract class CrisisLocalDataSource {
  Future<int> insertCrisis(CrisisModel crisis);
  Future<List<CrisisModel>> getAllCrisisByUser(int userId);
  Future<List<CrisisModel>> getCrisisByDateAndUser(String date, int userId);
  Future<int> deleteCrisis(int id);
  Future<int> updateCrisis(CrisisModel crisis);
}

// permite cambiar de DB sin que se afecte la app
class CrisisLocalDataSourceImpl implements CrisisLocalDataSource {
  final Database db;

  CrisisLocalDataSourceImpl(this.db);

  @override
  Future<int> insertCrisis(CrisisModel crisis) async {
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

  @override
  Future<List<CrisisModel>> getCrisisByDateAndUser(
    String date,
    int userId,
  ) async {
    final result = await db.query(
      'crisis',
      where: 'crisisDate = ? AND userId = ?',
      whereArgs: [date, userId],
    );
    return result.map((map) => CrisisModel.fromMap(map)).toList();
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
}
