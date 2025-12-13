// domain/usecases/get_details_by_crisis.dart
import '../../diary_domain.dart';

class GetDetailsByCrisis {
  final CrisisDetailRepository repository;

  GetDetailsByCrisis(this.repository);

  Future<List<CrisisDetalle>> call(int crisisId) async {
    return await repository.getByCrisisId(crisisId);
  }
}
