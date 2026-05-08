import '../entities/patient_entity.dart';

abstract class DoctorRepository {
  Future<List<PatientEntity>> getLinkedPatients();
  Future<void> linkPatient(int patientId);
}
