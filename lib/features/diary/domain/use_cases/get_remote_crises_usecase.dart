import 'package:app/features/diary/diary.dart';

class GetRemoteCrisesByDayAndUserUseCase {
  final CrisisRepository repository;

  GetRemoteCrisesByDayAndUserUseCase(this.repository);

  Future<List<Crisis>> call(DateTime day, int userId) async {
    return await repository.getCrisesRemoteByDayAndUser(day, userId);
  }
}

class GetRemoteCrisesDaysByUserUseCase {
  final CrisisRepository repository;

  GetRemoteCrisesDaysByUserUseCase(this.repository);

  Future<List<DateTime>> call(int userId) async {
    return await repository.getCrisesRemoteDaysByUser(userId);
  }
}

class GetRemoteCrisesByMonthAndYearUseCase {
  final CrisisRepository repository;

  GetRemoteCrisesByMonthAndYearUseCase(this.repository);

  Future<List<Crisis>> call(int month, int year, int userId) async {
    return await repository.getCrisesRemoteByMonthAndYear(month, year, userId);
  }
}
