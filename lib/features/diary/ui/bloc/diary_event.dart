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