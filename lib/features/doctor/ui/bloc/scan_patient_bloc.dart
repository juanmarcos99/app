import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/doctor/domain/repositories/doctor_repository.dart';
import 'scan_patient_event.dart';
import 'scan_patient_state.dart';

export 'scan_patient_event.dart';
export 'scan_patient_state.dart';

class ScanPatientBloc extends Bloc<ScanPatientEvent, ScanPatientState> {
  final DoctorRepository doctorRepository;

  ScanPatientBloc({required this.doctorRepository}) : super(ScanPatientInitial()) {
    on<PatientScanned>(_onPatientScanned);
  }

  Future<void> _onPatientScanned(
    PatientScanned event,
    Emitter<ScanPatientState> emit,
  ) async {
    emit(ScanPatientLoading());
    try {
      await doctorRepository.linkPatient(event.patientId);
      emit(ScanPatientSuccess(event.patientId));
    } catch (e) {
      debugPrint("Error al vincular el paciente: $e");
      emit(ScanPatientError("Error al vincular el paciente: $e"));
    }
  }
}
