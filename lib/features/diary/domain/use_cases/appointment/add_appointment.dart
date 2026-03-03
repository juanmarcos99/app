import '../../../diary.dart';

class AddAppointment {
  final AppointmentRepository repository;
  AddAppointment(this.repository);
  Future<void> call(Appointment appointment) {
    return repository.addAppointment(appointment);
  }
}
