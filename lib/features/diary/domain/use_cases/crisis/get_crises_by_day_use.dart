import 'package:app/features/diary/diary.dart';

class GetCrisesByDay {
  final CrisisRepository repository;
  GetCrisesByDay(this.repository);

  Future<List<Crisis>> call(DateTime day, int userId) async {
    return await repository.getCrisesByDayAndUser(day, userId);
  }
}