import 'package:equatable/equatable.dart';
import '../../diary.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object?> get props => [];
}

class AddCrisisEvent extends DiaryEvent {
  final Crisis crisis;

  const AddCrisisEvent(this.crisis);

  @override
  List<Object?> get props => [crisis];
}

class DaySelectedEvent extends DiaryEvent {
  final DateTime day;
  const DaySelectedEvent(this.day);

  @override
  List<Object?> get props => [day];
}
