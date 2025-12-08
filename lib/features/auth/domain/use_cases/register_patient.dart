import 'package:app/features/auth/domain/auth_domain.dart';

class RegisterPatient {
  final PatientRepository userRepository;

  RegisterPatient({required this.userRepository});
  Future<void> call(Patient patient) async {
    await userRepository.registerPatient(patient);
  }
}
