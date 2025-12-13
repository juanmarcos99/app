// domain/usecases/delete_crisis_detail.dart
import '../../diary_domain.dart';

class DeleteCrisisDetail {
  final CrisisDetailRepository repository;

  DeleteCrisisDetail(this.repository);

  Future<void> call(int detalleId) async {
    await repository.deleteDetail(detalleId);
  }
}
