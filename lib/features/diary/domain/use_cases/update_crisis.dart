import 'package:app/features/diary/diary.dart';
class UpdateCrisis {
  final CrisisRepository repository;
  UpdateCrisis(this.repository);

  Future<void> call(Crisis crisis) async {
    return await repository.updateCrisis(crisis);
  }
}