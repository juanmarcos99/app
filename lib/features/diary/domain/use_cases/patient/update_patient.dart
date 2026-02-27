import 'package:app/features/auth/auth.dart';

class UpdatePatient {
  final PatientRepository repository;

  UpdatePatient(this.repository);
  Future<void> call(Patient patient) {
    return repository.updatePatient(patient);
  }
}
