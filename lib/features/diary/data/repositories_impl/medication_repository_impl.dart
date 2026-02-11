import '../../diary.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource localDataSource;

  MedicationRepositoryImpl(this.localDataSource);

    @override
  Future<void> addMedication(Medication medication) async {
    final model = MedicationModel(
      id: medication.id,
      userId: medication.userId,
      name: medication.name,
      dosage: medication.dosage,
      notes: medication.notes,
      schedules: medication.schedules,
    );

    await localDataSource.addMedication(model);
  }

 @override
  Future<void> updateMedication(Medication medication) async {
    final model = MedicationModel(
      id: medication.id,
      userId: medication.userId,
      name: medication.name,
      dosage: medication.dosage,
      notes: medication.notes,
      schedules: medication.schedules,
    );

    await localDataSource.updateMedication(model);
  }

  @override
  Future<void> deleteMedication(int id) async {
    await localDataSource.deleteMedication(id);
  }

  @override
  Future<Medication?> getMedicationById(int id) async {
    final model = await localDataSource.getMedicationById(id);
    return model; // MedicationModel extiende Medication
  }

   @override
  Future<List<Medication>> getMedicationsByUser(int userId) async {
    final result = await localDataSource.getMedicationsByUser(userId);
    return result; // MedicationModel extiende Medication
  }

  @override
  Future<List<Schedule>> getSchedulesWithNotificationIds(
    int medicationId,
  ) async {
    final result = await localDataSource.getSchedulesByMedication(medicationId);
    return result;
  }
}
