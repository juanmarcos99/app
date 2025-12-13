import 'package:equatable/equatable.dart';
import '../../domain/entities/crisis.dart';

abstract class DiaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiaryLoaded extends DiaryState {
  final List<Crisis> crises;
  final DateTime selectedDay;

  DiaryLoaded({required this.crises, required this.selectedDay});

  @override
  List<Object?> get props => [crises, selectedDay];
}

class DiaryError extends DiaryState {
  final String message;
  DiaryError(this.message);

  @override
  List<Object?> get props => [message];
}
