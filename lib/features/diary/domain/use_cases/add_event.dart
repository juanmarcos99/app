import '../../diary.dart';

class AddAdverseEvent {
  final AdverseEventRepository repository;

  AddAdverseEvent(this.repository);

  Future<void> call(AdverseEvent event) async {
    await repository.addEvent(event);
  }
}
