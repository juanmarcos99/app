// domain/usecases/add_crisis_detail.dart
import 'package:app/features/diary/domain/entities/crisis_detail.dart';
import 'package:app/features/diary/domain/repositories/crisis_detail_repository.dart';

class AddCrisisDetail {
  final CrisisDetailRepository repository;

  AddCrisisDetail(this.repository);

  Future<int> call(CrisisDetalle detalle) async {
    if (detalle.cantidad <= 0) {
      throw Exception("La cantidad debe ser mayor que cero");
    }
    return await repository.addDetail(detalle);
  }
}
