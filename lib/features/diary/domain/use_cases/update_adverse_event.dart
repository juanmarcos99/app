import '../../diary.dart';
class UpdateAdverseEvent {
  final AdverseEventRepository repository;
  UpdateAdverseEvent(this.repository);

  Future<void> call(AdverseEvent event) async {
    return await repository.updateEvent(event);
  }
}