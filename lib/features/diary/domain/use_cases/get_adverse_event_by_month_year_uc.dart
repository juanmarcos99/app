import '../../diary.dart';
class GetAdverseEventsByMonthAndYearUseCase {
  final AdverseEventRepository repository;

  GetAdverseEventsByMonthAndYearUseCase(this.repository);

  Future<List<AdverseEvent>> call({
    required int month,
    required int year,
    required int userId,
  }) async {
    return await repository.getAdverseEventByMonthAndYear(month, year, userId);
  }
}
