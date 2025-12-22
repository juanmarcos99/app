import 'package:app/features/diary/diary.dart';

abstract class DiaryState {}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiaryError extends DiaryState {
  final String message;
  DiaryError(this.message);
}

//estado para el cambio de día
class DayChangedState extends DiaryState {
  final DateTime selectedDay;
  DayChangedState(this.selectedDay);
}

//añade la crisis
class CrisisAdded extends DiaryState {
  final CrisisModel crisis;
  CrisisAdded(this.crisis);
}

//para las tarjetas
class TarjetasLoaded extends DiaryState {
  final List<Crisis> crises;

  TarjetasLoaded(this.crises);
}

class TarjetasError extends DiaryState {
  final String message;

  TarjetasError(this.message);
}

//para el calendario
class CalendarLoaded extends DiaryState {
  final  Set <DateTime> crisisDays;
  CalendarLoaded(this.crisisDays);
}

class CalendarError extends DiaryState {
  final String message;
  CalendarError(this.message);
}

//estado para añadir un evento adverso
class AdverseEventAdded extends DiaryState {
  final AdverseEvent av;
  AdverseEventAdded(this.av);
}
