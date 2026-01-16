import '../../../diary.dart';

class GetMedicationsByUser {
  final MedicationRepository repository;

  GetMedicationsByUser(this.repository);

  Future<List<Medication>> call(int userId) {
    return repository.getMedicationsByUser(userId);
  }
}
