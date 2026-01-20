import '../../../diary.dart';

class GetSchedulesWithNotificationIdsUseCase {
  final MedicationRepository repository;

  GetSchedulesWithNotificationIdsUseCase(this.repository);

  Future<List<Schedule>> call(int medicationId) {
    return repository.getSchedulesWithNotificationIds(medicationId);
  }
}
