import 'package:equatable/equatable.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();

  @override
  List<Object?> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class CrisisAdded extends DiaryState {}

class DiaryFailure extends DiaryState {
  final String message;

  const DiaryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DaySelected extends DiaryState {
  final DateTime selectedDay;
  const DaySelected(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
