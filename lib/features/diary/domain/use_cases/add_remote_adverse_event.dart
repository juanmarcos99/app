import 'package:app/features/diary/diary.dart';

class AddRemoteAdverseEvent {
  final AdverseEventRepository repository;

  AddRemoteAdverseEvent(this.repository);

  Future<void> call(AdverseEvent event) async {
    return await repository.addRemoteEvent(event);
  }
}
