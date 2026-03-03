import 'package:sqflite/sqflite.dart';
import '../../diary.dart';

abstract class AppointmentLocalDataSource {
  Future<int> addAppointment(AppointmentModel appointment);
  Future<int> updateAppointment(AppointmentModel appointment);
  Future<int> deleteAppointment(int id);

  Future<AppointmentModel?> getAppointmentById(int id);
  Future<List<AppointmentModel>> getAppointmentsByUser(int userId);
}

class AppointmentLocalDataSourceImpl implements AppointmentLocalDataSource {
  final Database db;

  AppointmentLocalDataSourceImpl(this.db);

  @override
  Future<int> addAppointment(AppointmentModel appointment) async {
    try {
      final result = await db.insert('appointments', appointment.toMap());
      return result;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<int> updateAppointment(AppointmentModel appointment) async {
    try {
      final result = await db.update(
        'appointments',
        appointment.toMap(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );
      return result;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<int> deleteAppointment(int id) async {
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<AppointmentModel?> getAppointmentById(int id) async {
    final result = await db.query(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return AppointmentModel.fromMap(result.first);
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByUser(int userId) async {
    final result = await db.query(
      'appointments',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return result.map((m) => AppointmentModel.fromMap(m)).toList();
  }
}
