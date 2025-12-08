import 'package:app/features/auth/domain/auth_domain.dart';

class RegisterPatient {
  final PatientRepository patientRepository;

  RegisterPatient(this.patientRepository);

  Future<void> call(Patient patient) async {
    await patientRepository.registerPatient(patient);
  }
}
