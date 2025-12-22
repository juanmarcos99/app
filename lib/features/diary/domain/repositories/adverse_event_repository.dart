import '../../diary.dart';

abstract class AdverseEventRepository {
  Future<void> addEvent(AdverseEvent event);
  
}
