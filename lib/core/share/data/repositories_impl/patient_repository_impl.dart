import 'package:app/features/auth/auth.dart';

class PatientRepositoryImpl implements PatientRepository {
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

  @override
  Future<Patient?> getPatientByUserId(int userId) async {
    final patientModel = await localDataSource.getPatientByUserId(userId);
    return patientModel;
  }

  @override
  Future<void> updatePatient(Patient patient) async {
    final patientModel = PatientModel(
      userId: patient.userId,
      caregiverNumber: patient.caregiverNumber,
      caregiverEmail: patient.caregiverEmail,
    );
    await localDataSource.updatePatient(patientModel);
  }
}
