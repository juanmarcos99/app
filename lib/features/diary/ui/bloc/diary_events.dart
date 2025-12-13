import 'package:equatable/equatable.dart';
import '../../domain/entities/crisis.dart';

abstract class DiaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// cargar todas las crisis de un usuario
class LoadCrisisEvent extends DiaryEvent {
  final int userId;
  LoadCrisisEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// añadir una crisis nueva
class AddCrisisEvent extends DiaryEvent {
  final Crisis crisis;
  AddCrisisEvent(this.crisis);

  @override
  List<Object?> get props => [crisis];
}

// seleccionar un día en el calendario
class SelectDayEvent extends DiaryEvent {
  final DateTime day;
  SelectDayEvent(this.day);

  @override
  List<Object?> get props => [day];
}
