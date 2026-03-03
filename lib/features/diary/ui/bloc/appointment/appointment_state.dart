import 'package:equatable/equatable.dart';
import '../../../../diary/diary.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class AppointmentInitial extends AppointmentState {}

// Estado de carga
class AppointmentLoading extends AppointmentState {}

// Estado cuando ya tenemos la lista de citas
class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  const AppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

// Estado cuando ocurre un error
class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado cuando se añade una cita
class AppointmentAdded extends AppointmentState {
  final Appointment appointment;

  const AppointmentAdded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

// Estado cuando se elimina una cita
class AppointmentDeleted extends AppointmentState {
  final Appointment appointment;

  const AppointmentDeleted(this.appointment);

  @override
  List<Object?> get props => [appointment];
}
