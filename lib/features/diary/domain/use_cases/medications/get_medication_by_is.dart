import '../../../diary.dart';

class GetMedicationById {
  final MedicationRepository repository;

  GetMedicationById(this.repository);

  Future<Medication?> call(int id) {
    return repository.getMedicationById(id);
  }
}
