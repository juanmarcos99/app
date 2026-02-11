import 'package:equatable/equatable.dart';
import '../../../../diary/diary.dart';

abstract class MedicationEvent extends Equatable {
  const MedicationEvent();

  @override
  List<Object?> get props => [];
}

class LoadMedicationsEvent extends MedicationEvent {
  final int userId;

  const LoadMedicationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Añadir una medicación

class AddMedicationEvent extends MedicationEvent {
  final Medication medication;
  final bool shouldScheduleNotifications;

  const AddMedicationEvent(this.medication, this.shouldScheduleNotifications);

  @override
  List<Object?> get props => [medication, shouldScheduleNotifications];
}

//  Actualizar una medicación

class UpdateMedicationEvent extends MedicationEvent {
  final Medication medication;
  final bool shouldScheduleNotifications;

  const UpdateMedicationEvent(
    this.medication, {
    required this.shouldScheduleNotifications,
  });

  @override
  List<Object?> get props => [medication, shouldScheduleNotifications];
}

//  Eliminar una medicación

class DeleteMedicationEvent extends MedicationEvent {
  final int medicationId;

  const DeleteMedicationEvent(this.medicationId);

  @override
  List<Object?> get props => [medicationId];
}
