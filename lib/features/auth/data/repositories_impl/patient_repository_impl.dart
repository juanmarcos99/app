import 'package:app/features/auth/data/auth_data.dart';
import 'package:app/features/auth/domain/auth_domain.dart';

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
