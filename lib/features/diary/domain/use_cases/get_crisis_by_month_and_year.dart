import '../../diary.dart';
class GetCrisesByMonthAndYearUseCase {
  final CrisisRepository repository;

  GetCrisesByMonthAndYearUseCase(this.repository);

  Future<List<Crisis>> call({
    required int month,
    required int year,
    required int userId,
  }) async {
    return await repository.getCrisesByMonthAndYear(month, year, userId);
  }
}
