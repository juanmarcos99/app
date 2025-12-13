// domain/usecases/delete_crisis.dart
import '../../repositories/crisis_repository.dart';

class DeleteCrisis {
  final CrisisRepository repository;

  DeleteCrisis(this.repository);

  Future<void> call(int crisisId) async {
    await repository.deleteCrisis(crisisId);
  }
}
