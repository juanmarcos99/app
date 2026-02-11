import 'package:app/features/auth/auth.dart';

class RegisterPatient {
  final PatientRepository patientRepository;

  RegisterPatient(this.patientRepository);

  Future<void> call(Patient patient) async {
    await patientRepository.registerPatient(patient);
  }
}
