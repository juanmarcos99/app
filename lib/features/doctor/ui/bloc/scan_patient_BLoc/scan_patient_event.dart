import 'package:equatable/equatable.dart';

abstract class ScanPatientEvent extends Equatable {
  const ScanPatientEvent();

  @override
  List<Object?> get props => [];
}

class PatientScanned extends ScanPatientEvent {
  final int patientId;

  const PatientScanned(this.patientId);

  @override
  List<Object?> get props => [patientId];
}
