import 'package:app/features/diary/diary.dart';
abstract class DiaryEvent {}

class AddCrisisEvent extends DiaryEvent {
  final CrisisModel crisis;
  AddCrisisEvent(this.crisis);
}

class DayChangeEvent extends DiaryEvent {
  final DateTime newDay;
  DayChangeEvent(this.newDay);
}

class LoadTarjetasEvent extends DiaryEvent {
  final int userId;
  final DateTime date;
  LoadTarjetasEvent({required this.userId, required this.date});
}

class LoadCalendarEvent extends DiaryEvent {
  final int userId;
  LoadCalendarEvent(this.userId);
}

class AddAdverseEventEvent extends DiaryEvent {
  final AdverseEvent av;
 
  AddAdverseEventEvent(this.av);
}

class DeleteCrisisEvent extends DiaryEvent {
  final int crisisId;
  DeleteCrisisEvent(this.crisisId);
}

class DeleteAdverseEventEvent extends DiaryEvent {
  final int adverseEventId;
  DeleteAdverseEventEvent(this.adverseEventId);
}
