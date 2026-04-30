import '../../diary.dart';

abstract class AdverseEventRepository {
  Future<void> addEvent(AdverseEvent event);
  //para las tarjetas
  Future<List<AdverseEvent>> getAdverseEventByDayAndUser(
    DateTime day,
    int userId,
  );
  //para los punticos del calendario de los dias q hay crisis
  Future<List<DateTime>> getAdverseEventDaysByUser(int userId);

  Future<void> deleteEvent(int eventId);

  Future<void> updateEvent(AdverseEvent event);

  //para obtener los eventos adversos por id mes y año
  Future<List<AdverseEvent>> getAdverseEventByMonthAndYear(
    int month,
    int year,
    int userId,
  );
  // Métodos Remotos (Supabase)
  Future<void> addRemoteEvent(AdverseEvent event);
  Future<void> updateRemoteEvent(AdverseEvent event);
  Future<void> deleteRemoteEvent(int eventId);
  Future<List<AdverseEvent>> getAdverseEventremotesByDayAndUser(DateTime day, int userId);
  Future<List<DateTime>> getAdverseEventremotesDaysByUser(int userId);
  Future<List<AdverseEvent>> getAdverseEventremotesByMonthAndYear(int month, int year, int userId);
}
