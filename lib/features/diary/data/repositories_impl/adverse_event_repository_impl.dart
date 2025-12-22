import '../../diary.dart';

class AdverseEventRepositoryImpl implements AdverseEventRepository {
  final AdverseEventLocalDataSource localDataSource;
  AdverseEventRepositoryImpl(this.localDataSource);
  @override
  Future<void> addEvent(AdverseEvent event) {
    final model = AdverseEventModel(
      id: event.id,
      registerDate: event.registerDate,
      eventDate: event.eventDate,
      description: event.description,
      userId: event.userId,
    );
    return localDataSource.addAdverseEvent(model);
  }

  @override
  Future<List<AdverseEvent>> getAdverseEventByDayAndUser(
    DateTime day,
    int userId,
  ) async {
    final result = await localDataSource.getAdverseEventByDayAndUser(
      day,
      userId,
    );
    return result;
  }

  @override
  Future<List<DateTime>> getAdverseEventDaysByUser(int userId) async {
    final result = await localDataSource.getAdverseEventDaysByUser(userId);
    return result;
  }
}
