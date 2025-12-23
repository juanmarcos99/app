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
}
