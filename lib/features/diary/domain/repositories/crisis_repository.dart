import '../../diary.dart';

abstract class CrisisRepository {
  Future<void> addCrisis(Crisis crisis);
  Future<List<Crisis>> getCrisesByDay(DateTime day, String userId);
}
