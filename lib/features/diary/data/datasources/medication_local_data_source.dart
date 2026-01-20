import 'package:sqflite/sqflite.dart';
import '../../diary.dart'; // aquí tienes tus entidades y modelos

abstract class MedicationLocalDataSource {
  Future<int> addMedication(MedicationModel medication);
  Future<int> updateMedication(MedicationModel medication);
  Future<int> deleteMedication(int id);

  Future<MedicationModel?> getMedicationById(int id);
  Future<List<MedicationModel>> getMedicationsByUser(int userId);

  Future<List<ScheduleModel>> getSchedulesByMedication(int medicationId);
}

class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  final Database db;

  MedicationLocalDataSourceImpl(this.db);

  // -------------------------------------------------------------
  // Insertar medicamento + horarios
  // -------------------------------------------------------------
  @override
  Future<int> addMedication(MedicationModel medication) async {
    try {
      // Insertamos el medicamento en la tabla correcta
      final medId = await db.insert('medications', medication.toMap());

      // Insertamos los horarios asociados en la tabla schedules
      for (final schedule in medication.schedules!) {
        final scheduleModel = ScheduleModel(
          id: schedule.id,
          medicationId: medId,
          time: schedule.time,
          notificationId: schedule.notificationId,
        );

        await db.insert('schedules', scheduleModel.toMap());
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
        'medications',
        medication.toMap(),
        where: 'id = ?',
        whereArgs: [medication.id],
      );

      // Borramos horarios anteriores
      await db.delete(
        'schedules',
        where: 'medicationId = ?',
        whereArgs: [medication.id],
      );

      // Insertamos los nuevos horarios
      for (final schedule in medication.schedules!) {
        final scheduleModel = ScheduleModel(
          id: schedule.id,
          medicationId: medication.id!,
          time: schedule.time,
          notificationId: schedule.notificationId,
        );

        await db.insert('schedules', scheduleModel.toMap());
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
    return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  // -------------------------------------------------------------
  // Obtener horarios por medicamento
  // -------------------------------------------------------------
  @override
  Future<List<ScheduleModel>> getSchedulesByMedication(int medicationId) async {
    final result = await db.query(
      'schedules',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );

    return result.map((m) => ScheduleModel.fromMap(m)).toList();
  }

  // -------------------------------------------------------------
  // Obtener medicamento por ID (incluye horarios)
  // -------------------------------------------------------------
  @override
  Future<MedicationModel?> getMedicationById(int id) async {
    final result = await db.query(
      'medications',
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
      'medications',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    final List<MedicationModel> list = [];

    for (final map in result) {
      final schedules = await getSchedulesByMedication(map['id'] as int);
      list.add(MedicationModel.fromMap(map, schedules));
    }

    return list;
  }
}
