import '../../../diary.dart';

class GetAppointmentsByUser {
  final AppointmentRepository repository;
  GetAppointmentsByUser(this.repository);
  Future<List<Appointment>> call(int userId) {
    return repository.getAppointmentsByUser(userId);
  }
}
