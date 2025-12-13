// domain/usecases/update_crisis_detail.dart
import '../../diary_domain.dart';
class UpdateCrisisDetail {
  final CrisisDetailRepository repository;

  UpdateCrisisDetail(this.repository);

  Future<void> call(CrisisDetalle detalle) async {
    if (detalle.id == null) {
      throw Exception("El detalle debe tener un ID para actualizarse");
    }
    await repository.updateDetail(detalle);
  }
}
