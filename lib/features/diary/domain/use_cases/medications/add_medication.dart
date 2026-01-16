
import '../../../diary.dart';

class AddMedication {
  final MedicationRepository repository;

  AddMedication(this.repository);

  Future<void> call(Medication medication) {
    return repository.addMedication(medication);
  }
}
