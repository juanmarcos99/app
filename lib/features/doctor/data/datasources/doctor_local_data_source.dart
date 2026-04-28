import 'package:sqflite/sqflite.dart';

abstract class DoctorLocalDataSource {
  Future<List<int>> getLinkedPatientIds();
  Future<void> linkPatient(int patientId);
}

class DoctorLocalDataSourceImpl implements DoctorLocalDataSource {
  final Database database;

  DoctorLocalDataSourceImpl(this.database);

  @override
  Future<List<int>> getLinkedPatientIds() async {
    final List<Map<String, dynamic>> maps = await database.query('doctor_linked_patients');
    return List.generate(maps.length, (i) {
      return maps[i]['patient_id'] as int;
    });
  }

  @override
  Future<void> linkPatient(int patientId) async {
    await database.insert(
      'doctor_linked_patients',
      {'patient_id': patientId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
