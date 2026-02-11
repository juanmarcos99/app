import 'package:app/features/auth/auth.dart';

class PatientRepositoryImpl extends PatientRepository {
  final PatientLocalDataSources localDataSource;

  PatientRepositoryImpl(this.localDataSource);

  @override
  Future<void> registerPatient(Patient patient) async {
    final patientModel = PatientModel(
      userId: patient.userId,
      caregiverNumber: patient.caregiverNumber,
      caregiverEmail: patient.caregiverEmail,
    );
    await localDataSource.insertPatient(patientModel);
  }
}
