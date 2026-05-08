import 'package:equatable/equatable.dart';

abstract class ScanPatientState extends Equatable {
  const ScanPatientState();

  @override
  List<Object?> get props => [];
}

class ScanPatientInitial extends ScanPatientState {}

class ScanPatientLoading extends ScanPatientState {}

class ScanPatientSuccess extends ScanPatientState {
  final int patientId;

  const ScanPatientSuccess(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class ScanPatientError extends ScanPatientState {
  final String message;

  const ScanPatientError(this.message);

  @override
  List<Object?> get props => [message];
}
