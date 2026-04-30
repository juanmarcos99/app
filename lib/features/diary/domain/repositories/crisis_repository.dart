import '../../diary.dart';

abstract class CrisisRepository {
  Future<void> addCrisis(Crisis crisis);
  //para cargar las tarjetas
  Future<List<Crisis>> getCrisesByDayAndUser(DateTime day, int userId);
  //para los punticos del calendario de los dias q hay crisis
  Future<List<DateTime>> getCrisesDaysByUser(int userId);
  //para eliminar crisis
  Future<void> deleteCrisis(int crisisId);
  //para actualizar crisis
  Future<void> updateCrisis(Crisis crisis);
  //para obtener una crisis por id mes y año
  Future<List<Crisis>> getCrisesByMonthAndYear(int month, int year, int userId);
  //obtener el último día con crisis
  Future<DateTime?> getLastCrisisDayByUser(int userId);
  // Métodos Remotos (Supabase)
  Future<void> addRemoteCrisis(Crisis crisis);
  Future<void> updateRemoteCrisis(Crisis crisis);
  Future<void> deleteRemoteCrisis(int crisisId);
  Future<List<Crisis>> getCrisesRemoteByDayAndUser(DateTime day, int userId);
  Future<List<DateTime>> getCrisesRemoteDaysByUser(int userId);
  Future<List<Crisis>> getCrisesRemoteByMonthAndYear(int month, int year, int userId);
}
