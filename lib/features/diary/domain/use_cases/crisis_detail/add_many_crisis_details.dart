// domain/usecases/add_many_crisis_details.dart
import '../../diary_domain.dart';
class AddManyCrisisDetails {
  final CrisisDetailRepository repository;

  AddManyCrisisDetails(this.repository);

  Future<void> call(List<CrisisDetalle> detalles) async {
    if (detalles.isEmpty) {
      throw Exception("Debe haber al menos un detalle");
    }
    await repository.addMany(detalles);
  }
}
