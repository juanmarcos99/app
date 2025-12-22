import '../../diary.dart';
class GetAdverseEventDaysByUser {
  final AdverseEventRepository repository;

  GetAdverseEventDaysByUser(this.repository);

  Future<List<DateTime>> call(int userId) {
    return repository.getAdverseEventDaysByUser(userId);
  }
}
