import 'package:equatable/equatable.dart';
import '../../../../diary/diary.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

// Cargar citas de un usuario
class LoadAppointmentsEvent extends AppointmentEvent {
  final int userId;

  const LoadAppointmentsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Añadir una cita
class AddAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  const AddAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

// Eliminar una cita
class DeleteAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  const DeleteAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}
