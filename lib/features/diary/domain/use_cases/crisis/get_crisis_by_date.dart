// domain/usecases/get_crisis_by_date.dart
import '../../entities/crisis.dart';
import '../../repositories/crisis_repository.dart';

class GetCrisisByDate {
  final CrisisRepository repository;

  GetCrisisByDate(this.repository);

  Future<List<Crisis>> call(int userId, DateTime date) async {
    return await repository.getCrisisByDate(userId: userId, date: date);
  }
}
