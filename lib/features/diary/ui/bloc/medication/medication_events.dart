import 'package:equatable/equatable.dart';
import '../../../../diary/diary.dart';

abstract class MedicationEvent extends Equatable {
  const MedicationEvent();

  @override
  List<Object?> get props => [];
}

// -------------------------------------------------------------
// 🔥 1. Cargar todas las medicaciones del usuario
// -------------------------------------------------------------
class LoadMedicationsEvent extends MedicationEvent {
  final int userId;

  const LoadMedicationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// -------------------------------------------------------------
// 🔥 2. Añadir una medicación
// -------------------------------------------------------------
class AddMedicationEvent extends MedicationEvent {
  final Medication medication;
  final bool shouldScheduleNotifications;

  const AddMedicationEvent(this.medication, this.shouldScheduleNotifications);

  @override
  List<Object?> get props => [medication, shouldScheduleNotifications];
}

// -------------------------------------------------------------
// 🔥 3. Actualizar una medicación
// -------------------------------------------------------------
class UpdateMedicationEvent extends MedicationEvent {
  final Medication medication;

  const UpdateMedicationEvent(this.medication);

  @override
  List<Object?> get props => [medication];
}

// -------------------------------------------------------------
// 🔥 4. Eliminar una medicación
// -------------------------------------------------------------
class DeleteMedicationEvent extends MedicationEvent {
  final int medicationId;

  const DeleteMedicationEvent(this.medicationId);

  @override
  List<Object?> get props => [medicationId];
}
