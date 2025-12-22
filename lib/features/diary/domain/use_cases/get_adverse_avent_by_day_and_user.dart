import '../../diary.dart';

class GetAdverseAventByDayAndUser {
  final AdverseEventRepository repository;

  GetAdverseAventByDayAndUser(this.repository);

  Future<List<AdverseEvent>> call(DateTime day, int userId) async {
    return await repository.getAdverseEventByDayAndUser(day, userId);
  }
}