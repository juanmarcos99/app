import '../../diary.dart';
class DeleteCrisis {
  final CrisisRepository repository;

  DeleteCrisis(this.repository);

  Future<void> call(int crisisId) async {
    return await repository.deleteCrisis(crisisId);
  }
}