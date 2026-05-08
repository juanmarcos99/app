import 'package:equatable/equatable.dart';
import '../../domain/entities/patient_entity.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<PatientEntity> patients;

  const DoctorLoaded(this.patients);

  @override
  List<Object?> get props => [patients];
}

class DoctorError extends DoctorState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object?> get props => [message];
}
