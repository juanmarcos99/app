import 'package:app/features/auth/auth.dart';

abstract class PatientRepository {
  Future<void> registerPatient(Patient patient);
  Future<Patient?> getPatientByUserId(int userId);
  Future<void> updatePatient(Patient patient);
}
