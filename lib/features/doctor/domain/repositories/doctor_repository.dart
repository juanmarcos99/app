import '../entities/patient_lincked.dart';

abstract class DoctorRepository {
  Future<List<PatientLincked>> getLinkedPatients();
  Future<void> linkPatient(int patientId);
}
