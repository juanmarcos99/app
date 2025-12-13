// data/datasources/crisis_detalle_local_data_source.dart
import 'package:app/features/diary/data/diary_data.dart';
import 'package:sqflite/sqflite.dart';

abstract class CrisisDetalleLocalDataSource {
  Future<int> insertDetalle(CrisisDetalleModel detalle);
  Future<void> insertMany(List<CrisisDetalleModel> detalles);
  Future<void> updateDetalle(CrisisDetalleModel detalle);
  Future<void> deleteDetalle(int id);
  Future<void> deleteByCrisisId(int crisisId);
  Future<List<CrisisDetalleModel>> getByCrisisId(int crisisId);
}


class CrisisDetalleLocalDataSourceImpl implements CrisisDetalleLocalDataSource {
  final Database db;

  CrisisDetalleLocalDataSourceImpl(this.db);

  @override
  Future<int> insertDetalle(CrisisDetalleModel detalle) async {
    return await db.insert('crisis_detalle', detalle.toMap());
  }

  @override
  Future<void> insertMany(List<CrisisDetalleModel> detalles) async {
    final batch = db.batch();
    for (var d in detalles) {
      batch.insert('crisis_detalle', d.toMap());
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateDetalle(CrisisDetalleModel detalle) async {
    await db.update(
      'crisis_detalle',
      detalle.toMap(),
      where: 'id = ?',
      whereArgs: [detalle.id],
    );
  }

  @override
  Future<void> deleteDetalle(int id) async {
    await db.delete(
      'crisis_detalle',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteByCrisisId(int crisisId) async {
    await db.delete(
      'crisis_detalle',
      where: 'crisisId = ?',
      whereArgs: [crisisId],
    );
  }

  @override
  Future<List<CrisisDetalleModel>> getByCrisisId(int crisisId) async {
    final result = await db.query(
      'crisis_detalle',
      where: 'crisisId = ?',
      whereArgs: [crisisId],
    );
    return result.map((m) => CrisisDetalleModel.fromMap(m)).toList();
  }
}
