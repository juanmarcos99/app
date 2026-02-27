import 'package:app/features/auth/data/models/patient_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class PatientLocalDataSources {
  Future<int> insertPatient(PatientModel patient);
  Future<void> updatePatient(PatientModel patient);
  Future<PatientModel?> getPatientByUserId(int userId);
}

class PatientLocalDataSourcesImpl extends PatientLocalDataSources {
  final Database db;

  PatientLocalDataSourcesImpl(this.db);

  @override
  Future<int> insertPatient(PatientModel patient) async {
    return await db.insert('patients', patient.toMap());
  }

  @override
  Future<void> updatePatient(PatientModel patient) async {
    final rowsAffected = await db.update(
      'patients',
      patient.toMap(),
      where: 'userId = ?',
      whereArgs: [patient.userId],
    );
    if (rowsAffected == 0) {
      throw Exception(
        "No se pudo actualizar: paciente con userId ${patient.userId} no existe",
      );
    }
  }
  @override
  Future<PatientModel?> getPatientByUserId(int userId) async {
    final result = await db.query(
      'patients',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return PatientModel.fromMap(result.first);
    }
    return null;
  }
}
