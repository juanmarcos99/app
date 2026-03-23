import 'package:app/features/diary/diary.dart';
class GetCrisesDays {
  final CrisisRepository repository;
  GetCrisesDays(this.repository);

  Future<List<DateTime>> call(int userId) async {
    return await repository.getCrisesDaysByUser(userId);
  }
}