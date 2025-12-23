import '../../diary.dart';
class DeleteAdverseEvent {
  final AdverseEventRepository repository;

  DeleteAdverseEvent(this.repository);

  Future<void> call(int eventId) async {
    await repository.deleteEvent(eventId);
  }
}