import 'package:sqflite/sqflite.dart';
import '../../diary.dart';

abstract class MedicationLocalDataSource {
  Future<int> addMedication(MedicationModel medication);
  Future<int> updateMedication(MedicationModel medication);
  Future<int> deleteMedication(int id);

  Future<MedicationModel?> getMedicationById(int id);
  Future<List<MedicationModel>> getMedicationsByUser(int userId);

  Future<List<String>> getSchedulesByMedication(int medicationId);
}

class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  final Database db;

  MedicationLocalDataSourceImpl(this.db);

  // -------------------------------------------------------------
  //  Insertar medicamento + horarios
  // -------------------------------------------------------------
  @override
  Future<int> addMedication(MedicationModel medication) async {
    try {
      // Insertamos el medicamento
      final medId = await db.insert('medicamentos', medication.toMap());

      // Insertamos los horarios asociados
      for (final time in medication.schedules!) {
        await db.insert('horarios', {
          'medicationId': medId,
          'time': time,
        });
      }

      return medId;
    } catch (e) {
      return -1;
    }
  }

  // -------------------------------------------------------------
  // Actualizar medicamento + horarios
  // -------------------------------------------------------------
  @override
  Future<int> updateMedication(MedicationModel medication) async {
    try {
      // Actualizamos el medicamento
      final result = await db.update(
        'medicamentos',
        medication.toMap(),
        where: 'id = ?',
        whereArgs: [medication.id],
      );

      // Borramos horarios anteriores
      await db.delete(
        'horarios',
        where: 'medicationId = ?',
        whereArgs: [medication.id],
      );

      // Insertamos los nuevos horarios
      for (final time in medication.schedules!) {
        await db.insert('horarios', {
          'medicationId': medication.id,
          'time': time,
        });
      }

      return result;
    } catch (e) {
      return -1;
    }
  }

  // -------------------------------------------------------------
  // Borrar medicamento + horarios (ON DELETE CASCADE)
  // -------------------------------------------------------------
  @override
  Future<int> deleteMedication(int id) async {
    return await db.delete('medicamentos', where: 'id = ?', whereArgs: [id]);
  }

  // -------------------------------------------------------------
  // Obtener horarios por medicamento
  // -------------------------------------------------------------
  @override
  Future<List<String>> getSchedulesByMedication(int medicationId) async {
    final result = await db.query(
      'horarios',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );

    return result.map((m) => m['time'] as String).toList();
  }

  // -------------------------------------------------------------
  // Obtener medicamento por ID (incluye horarios)
  // -------------------------------------------------------------
  @override
  Future<MedicationModel?> getMedicationById(int id) async {
    final result = await db.query(
      'medicamentos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final schedules = await getSchedulesByMedication(id);

    return MedicationModel.fromMap(result.first, schedules);
  }

  // -------------------------------------------------------------
  // Obtener todos los medicamentos de un usuario (incluye horarios)
  // -------------------------------------------------------------
  @override
  Future<List<MedicationModel>> getMedicationsByUser(int userId) async {
    final result = await db.query(
      'medicamentos',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    final List<MedicationModel> list = [];

    for (final map in result) {
      final schedules = await getSchedulesByMedication(
        int.parse(map['id'].toString()),
      );
      list.add(MedicationModel.fromMap(map, schedules));
    }

    return list;
  }
}
