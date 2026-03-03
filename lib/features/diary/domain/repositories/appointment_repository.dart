import '../../diary.dart';

abstract class AppointmentRepository {
  Future<void> addAppointment(Appointment appointment);  
  Future<void> deleteAppointment(int id);
  Future<Appointment?> getAppointmentById(int id);
  Future<List<Appointment>> getAppointmentsByUser(int userId);
}
