// domain/usecases/get_all_crisis_by_user.dart
import '../../entities/crisis.dart';
import '../../repositories/crisis_repository.dart';

class GetAllCrisisByUser {
  final CrisisRepository repository;

  GetAllCrisisByUser(this.repository);

  Future<List<Crisis>> call(int userId) async {
    return await repository.getAllCrisisByUser(userId);
  }
}
