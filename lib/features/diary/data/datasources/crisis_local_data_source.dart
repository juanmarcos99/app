// data/datasources/crisis_local_data_source.dart
import 'package:app/features/diary/data/diary_data.dart';
import 'package:sqflite/sqflite.dart';


abstract class CrisisLocalDataSource {
  Future<int> insertCrisis(CrisisModel crisis);
  Future<void> updateCrisis(CrisisModel crisis);
  Future<void> deleteCrisis(int id);
  Future<CrisisModel?> getCrisisById(int id);
  Future<List<CrisisModel>> getCrisisByUser(int userId);
  Future<List<CrisisModel>> getCrisisByUserAndDate(int userId, DateTime date);
}

class CrisisLocalDataSourceImpl implements CrisisLocalDataSource {
  final Database db;
  CrisisLocalDataSourceImpl(this.db);

  @override
  Future<int> insertCrisis(CrisisModel crisis) async {
    return await db.insert('crisis', crisis.toMap());
  }

  @override
  Future<void> updateCrisis(CrisisModel crisis) async {
    await db.update(
      'crisis',
      crisis.toMap(),
      where: 'id = ?',
      whereArgs: [crisis.id],
    );
  }

  @override
  Future<void> deleteCrisis(int id) async {
    await db.delete('crisis', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<CrisisModel?> getCrisisById(int id) async {
    final result = await db.query('crisis', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? CrisisModel.fromMap(result.first) : null;
  }

  @override
  Future<List<CrisisModel>> getCrisisByUser(int userId) async {
    final result = await db.query('crisis', where: 'usuarioId = ?', whereArgs: [userId]);
    return result.map((m) => CrisisModel.fromMap(m)).toList();
  }

  @override
  Future<List<CrisisModel>> getCrisisByUserAndDate(int userId, DateTime date) async {
    final result = await db.query(
      'crisis',
      where: 'usuarioId = ? AND fechaCrisis = ?',
      whereArgs: [userId, date.toIso8601String()],
    );
    return result.map((m) => CrisisModel.fromMap(m)).toList();
  }
}

