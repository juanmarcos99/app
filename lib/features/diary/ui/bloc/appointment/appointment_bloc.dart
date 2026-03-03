import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary/diary.dart';
import '../../../../../core/core.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AddAppointment addAppointment;
  final DeleteAppointment deleteAppointment;
  final GetAppointmentsByUser getAppointmentsByUser;
  final GetAppointmentById getAppointmentById;

  AppointmentBloc({
    required this.getAppointmentById,
    required this.addAppointment,
    required this.deleteAppointment,
    required this.getAppointmentsByUser,
  }) : super(AppointmentInitial()) {
    // Cargar citas
    on<LoadAppointmentsEvent>((event, emit) async {
      emit(AppointmentLoading());

      try {
        final appointments = await getAppointmentsByUser(event.userId);
        emit(AppointmentLoaded(appointments));
      } catch (e) {
        Logger.e(
          "Error en AppointmentBloc - LoadAppointmentsEvent: $e",
          error: e,
        );
        emit(AppointmentError("Error al cargar citas: $e"));
        debugPrint("Error al cargar citas: $e");
      }
    });

    // Añadir cita
    on<AddAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());

      try {
        // 1. Guardar la cita en la BD
        await addAppointment(event.appointment);
        emit(AppointmentAdded(event.appointment));

        // 2. Programar notificaciones
        final service = NotificationService();
        final appointmentDate = event.appointment.time!;

        // Notificación 2 días antes
        final twoDaysBefore = appointmentDate.subtract(const Duration(days: 2));
        if (twoDaysBefore.isAfter(DateTime.now())) {
          await service.scheduleOneTimeAlert(
            notificationId: event.appointment.notificationId!,
            scheduledDate: twoDaysBefore,
            title: "Recordatorio de cita médica",
            body: "Tu cita es en 2 días",
          );
        }

        // Notificación 1 día antes
        final oneDayBefore = appointmentDate.subtract(const Duration(days: 1));
        if (oneDayBefore.isAfter(DateTime.now())) {
          await service.scheduleOneTimeAlert(
            notificationId: event.appointment.notificationId! + 1,
            scheduledDate: oneDayBefore,
            title: "Recordatorio de cita médica",
            body: "Tu cita es mañana",
          );
        }

        // Notificación el mismo día
        if (appointmentDate.isAfter(DateTime.now())) {
          await service.scheduleOneTimeAlert(
            notificationId: event.appointment.notificationId! + 2,
            scheduledDate: appointmentDate,
            title: "Recordatorio de cita médica",
            body: "Tu cita es hoy",
          );
        }

        // 3. Refrescar lista de citas
        final appointments = await getAppointmentsByUser(
          event.appointment.userId!,
        );
        emit(AppointmentLoaded(appointments));
      } catch (e) {
        Logger.e(
          "Error en AppointmentBloc - AddAppointmentEvent: $e",
          error: e,
        );
        emit(AppointmentError("Error al añadir cita: $e"));
      }
    });

    // Eliminar cita
    on<DeleteAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());

      try {
        final service = NotificationService();

        // 1. Obtener la cita antes de eliminarla (para saber su notificationId base)
        final appointment = await getAppointmentById(event.appointment.id!);

        if (appointment != null && appointment.notificationId != null) {
          // Cancelar las tres notificaciones asociadas
          await service.cancelAlert(appointment.notificationId!);
          await service.cancelAlert(appointment.notificationId! + 1);
          await service.cancelAlert(appointment.notificationId! + 2);
        }

        // 2. Eliminar la cita de la BD
        await deleteAppointment(event.appointment.id!);

        // 3. Emitir estado de eliminado
        emit(AppointmentDeleted(event.appointment));

        // 4. Refrescar lista de citas
        final appointments = await getAppointmentsByUser(
          appointment?.userId ?? 0,
        );
        emit(AppointmentLoaded(appointments));
      } catch (e) {
        Logger.e(
          "Error en AppointmentBloc - DeleteAppointmentEvent: $e",
          error: e,
        );
        emit(AppointmentError("Error al eliminar cita: $e"));
      }
    });
  }
}
