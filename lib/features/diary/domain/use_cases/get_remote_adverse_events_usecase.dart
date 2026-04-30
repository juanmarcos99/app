import 'package:app/features/diary/diary.dart';

class GetRemoteAdverseEventsByDayAndUserUseCase {
  final AdverseEventRepository repository;

  GetRemoteAdverseEventsByDayAndUserUseCase(this.repository);

  Future<List<AdverseEvent>> call(DateTime day, int userId) async {
    return await repository.getAdverseEventremotesByDayAndUser(day, userId);
  }
}

class GetRemoteAdverseEventsDaysByUserUseCase {
  final AdverseEventRepository repository;

  GetRemoteAdverseEventsDaysByUserUseCase(this.repository);

  Future<List<DateTime>> call(int userId) async {
    return await repository.getAdverseEventremotesDaysByUser(userId);
  }
}

class GetRemoteAdverseEventsByMonthAndYearUseCase {
  final AdverseEventRepository repository;

  GetRemoteAdverseEventsByMonthAndYearUseCase(this.repository);

  Future<List<AdverseEvent>> call(int month, int year, int userId) async {
    return await repository.getAdverseEventremotesByMonthAndYear(month, year, userId);
  }
}
