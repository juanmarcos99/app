import 'package:app/core/core.dart';
import 'package:app/core/share/data/datasources/remote_data_sourse/adverse_event_remote_data_source.dart';
import '../../diary.dart';

class AdverseEventRepositoryImpl implements AdverseEventRepository {
  final AdverseEventLocalDataSource localDataSource;
  final AdverseEventRemoteDataSource remoteDataSource;

  AdverseEventRepositoryImpl(this.localDataSource, this.remoteDataSource);
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

  @override
  Future<void> deleteEvent(int id) {
    return localDataSource.deleteAdverseEvent(id);
  }
  
  @override
  Future<void> updateEvent(AdverseEvent event) {
    final model = AdverseEventModel(
      id: event.id,
      registerDate: event.registerDate,
      eventDate: event.eventDate,
      description: event.description,
      userId: event.userId,
    );
    return localDataSource.updateAdverseEvent(model);
  }

  @override
  Future<List<AdverseEvent>> getAdverseEventByMonthAndYear(
    int month,
    int year,
    int userId,
  ) async {
    final result = await localDataSource.getAdverseEventByMonthAndYear(
      month,
      year,
      userId,
    );
    return result;
  }

  @override
  Future<void> addRemoteEvent(AdverseEvent event) async {
    final model = AdverseEventModel(
      id: event.id,
      registerDate: event.registerDate,
      eventDate: event.eventDate,
      description: event.description,
      userId: event.userId,
    );
    try {
      await remoteDataSource.addEvent(model);
    } catch (e) {
      throw ServerException("Error remoto al añadir evento: ($e)");
    }
  }

  @override
  Future<void> updateRemoteEvent(AdverseEvent event) async {
    final model = AdverseEventModel(
      id: event.id,
      registerDate: event.registerDate,
      eventDate: event.eventDate,
      description: event.description,
      userId: event.userId,
    );
    try {
      await remoteDataSource.updateEvent(model);
    } catch (e) {
      throw ServerException("Error remoto al actualizar evento: ($e)");
    }
  }

  @override
  Future<void> deleteRemoteEvent(int eventId) async {
    try {
      await remoteDataSource.deleteEvent(eventId);
    } catch (e) {
      throw ServerException("Error remoto al eliminar evento: ($e)");
    }
  }
}
