import 'package:app/features/auth/data/models/patient_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class PatientLocalDataSources {
  Future<int> insertPatient(PatientModel patient);
}

class PatientLocalDataSourcesImpl extends PatientLocalDataSources {
  final Database db;

  PatientLocalDataSourcesImpl(this.db);

  @override
  Future<int> insertPatient(PatientModel patient) async {
    return await db.insert('patients', patient.toMap());
  }
}
