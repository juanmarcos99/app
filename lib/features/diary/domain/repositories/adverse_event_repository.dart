import '../../diary.dart';

abstract class AdverseEventRepository {
  Future<void> addEvent(AdverseEvent event);
  //para las tarjetas
  Future<List<AdverseEvent>> getAdverseEventByDayAndUser(DateTime day, int userId);
  //para los punticos del calendario de los dias q hay crisis
  Future<List<DateTime>> getAdverseEventDaysByUser(int userId);

  Future<void> deleteEvent(int eventId);

  Future<void> updateEvent(AdverseEvent event);
}
