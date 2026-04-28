import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_linked_patients_usecase.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';

export 'doctor_event.dart';
export 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final GetLinkedPatientsUseCase getLinkedPatientsUseCase;

  DoctorBloc({required this.getLinkedPatientsUseCase}) : super(DoctorInitial()) {
    on<LoadLinkedPatients>(_onLoadLinkedPatients);
  }

  Future<void> _onLoadLinkedPatients(
    LoadLinkedPatients event,
    Emitter<DoctorState> emit,
  ) async {
    emit(DoctorLoading());
    try {
      final patients = await getLinkedPatientsUseCase();
      emit(DoctorLoaded(patients));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
