import '../../../diary.dart';

class GetAppointmentById {
  final AppointmentRepository repository;
  GetAppointmentById(this.repository);
  Future<Appointment?> call(int id) {
    return repository.getAppointmentById(id);
  }
}
