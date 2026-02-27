import 'package:app/features/auth/auth.dart';

class GetPatientByUserId {
  final PatientRepository repository;

  GetPatientByUserId(this.repository);

  Future<Patient?> call(int userId) {
    return repository.getPatientByUserId(userId);
  }
}
