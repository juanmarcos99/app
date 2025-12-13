// domain/repositories/crisis_repository.dart
import '../entities/crisis.dart';

abstract class CrisisRepository {
  Future<int> createCrisis(Crisis crisis);
  Future<void> updateCrisis(Crisis crisis);
  Future<void> deleteCrisis(int crisisId);

  Future<Crisis?> getCrisisById(int crisisId);
  Future<List<Crisis>> getCrisisByDate({
    required int userId,
    required DateTime date,
  });
  Future<List<Crisis>> getAllCrisisByUser(int userId);
}
