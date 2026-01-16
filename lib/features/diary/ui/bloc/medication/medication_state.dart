import 'package:equatable/equatable.dart';
import '../../../../diary/diary.dart';

abstract class MedicationState extends Equatable {
  const MedicationState();

  @override
  List<Object?> get props => [];
}

// -------------------------------------------------------------
// 🔥 Estado inicial
// -------------------------------------------------------------
class MedicationInitial extends MedicationState {}

// -------------------------------------------------------------
// 🔥 Estado de carga
// -------------------------------------------------------------
class MedicationLoading extends MedicationState {}

// -------------------------------------------------------------
// 🔥 Estado cuando ya tenemos la lista de medicamentos
// -------------------------------------------------------------
class MedicationLoaded extends MedicationState {
  final List<Medication> medications;

  const MedicationLoaded(this.medications);

  @override
  List<Object?> get props => [medications];
}

// -------------------------------------------------------------
// 🔥 Estado cuando ocurre un error
// -------------------------------------------------------------
class MedicationError extends MedicationState {
  final String message;

  const MedicationError(this.message);

  @override
  List<Object?> get props => [message];
}

// -------------------------------------------------------------
// 🔥 Estado cuando se añade una medicación
// -------------------------------------------------------------
class MedicationAdded extends MedicationState {
  final Medication medication;

  const MedicationAdded(this.medication);

  @override
  List<Object?> get props => [medication];
}

// -------------------------------------------------------------
// 🔥 Estado cuando se actualiza una medicación
// -------------------------------------------------------------
class MedicationUpdated extends MedicationState {
  final Medication medication;

  const MedicationUpdated(this.medication);

  @override
  List<Object?> get props => [medication];
}

// -------------------------------------------------------------
// 🔥 Estado cuando se elimina una medicación
// -------------------------------------------------------------
class MedicationDeleted extends MedicationState {
  final int medicationId;

  const MedicationDeleted(this.medicationId);

  @override
  List<Object?> get props => [medicationId];
}
