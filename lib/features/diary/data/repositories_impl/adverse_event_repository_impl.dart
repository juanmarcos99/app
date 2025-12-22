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
}
