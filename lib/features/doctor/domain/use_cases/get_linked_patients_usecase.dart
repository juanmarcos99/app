import '../entities/patient_entity.dart';
import '../repositories/doctor_repository.dart';

class GetLinkedPatientsUseCase {
  final DoctorRepository repository;

  GetLinkedPatientsUseCase(this.repository);

  Future<List<PatientEntity>> call() async {
    return await repository.getLinkedPatients();
  }
}
