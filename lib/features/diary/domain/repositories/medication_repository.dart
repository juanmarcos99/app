import '../entities/medication.dart';
abstract class MedicationRepository {
  Future<void> addMedication(Medication medication);
  Future<void> updateMedication(Medication medication);
  Future<void> deleteMedication(int id);
  Future<Medication?> getMedicationById(int id);
  Future<List<Medication>> getMedicationsByUser(int userId);
}
