// domain/usecases/update_crisis.dart
import '../../entities/crisis.dart';
import '../../repositories/crisis_repository.dart';

class UpdateCrisis {
  final CrisisRepository repository;

  UpdateCrisis(this.repository);

  Future<void> call(Crisis crisis) async {
    if (crisis.id == null) {
      throw Exception("La crisis debe tener un ID para actualizarse");
    }
    await repository.updateCrisis(crisis);
  }
}
