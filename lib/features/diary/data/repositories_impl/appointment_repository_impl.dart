import '../../diary.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDataSource localDataSource;

  AppointmentRepositoryImpl(this.localDataSource);

  @override
  Future<void> addAppointment(Appointment appointment) async {
    final model = AppointmentModel(
      id: appointment.id,
      userId: appointment.userId,
      information: appointment.information,
      time: appointment.time,
      notificationId: appointment.notificationId,
    );

    await localDataSource.addAppointment(model);
  }

  @override
  Future<void> deleteAppointment(int id) async {
    await localDataSource.deleteAppointment(id);
  }

  @override
  Future<Appointment?> getAppointmentById(int id) async {
    final model = await localDataSource.getAppointmentById(id);
    return model; // AppointmentModel extiende Appointment
  }

  @override
  Future<List<Appointment>> getAppointmentsByUser(int userId) async {
    final result = await localDataSource.getAppointmentsByUser(userId);
    return result; // AppointmentModel extiende Appointment
  }
}
