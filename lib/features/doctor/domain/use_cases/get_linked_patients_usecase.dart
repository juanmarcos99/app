import '../entities/patient_lincked.dart';
import '../repositories/doctor_repository.dart';

class GetLinkedPatientsUseCase {
  final DoctorRepository repository;

  GetLinkedPatientsUseCase(this.repository);

  Future<List<PatientLincked>> call() async {
    return await repository.getLinkedPatients();
  }
}
