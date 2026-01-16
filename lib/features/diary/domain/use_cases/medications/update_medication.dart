import '../../../diary.dart';

class UpdateMedication {
  final MedicationRepository repository;

  UpdateMedication(this.repository);

  Future<void> call(Medication medication) {
    return repository.updateMedication(medication);
  }
}
