import '../../../diary.dart';

class DeleteMedication {
  final MedicationRepository repository;

  DeleteMedication(this.repository);

  Future<void> call(int id) {
    return repository.deleteMedication(id);
  }
}
