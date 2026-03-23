import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/diary.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetLastCrisisDayByUser getLastCrisisDayByUser;
  final GetMedicationsByUser getMedicationsByUser;
  final GetAppointmentsByUser getAppointmentsByUser;

  HomeBloc({
    required this.getLastCrisisDayByUser,
    required this.getMedicationsByUser,
    required this.getAppointmentsByUser,
  }) : super(HomeInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final List<String> notifications = [];

      // Última crisis registrada
      final lastCrisisDay = await getLastCrisisDayByUser(event.userId);
      if (lastCrisisDay != null) {
        notifications.add(
          "El último registro de crisis fue el día ${lastCrisisDay.toLocal().toString().split(' ')[0]}",
        );
      } else {
        notifications.add("Aún no has registrado ninguna crisis.");
      }

      // Medicamentos pendientes
      final medications = await getMedicationsByUser(event.userId);
      if (medications.isNotEmpty) {
        notifications.add(
          "Tienes ${medications.length} medicamentos pendientes por tomar.",
        );
      } else {
        notifications.add("No tienes medicamentos pendientes.");
      }

      // Citas médicas
      final appointments = await getAppointmentsByUser(event.userId);
      if (appointments.isNotEmpty) {
        notifications.add(
          "Tienes ${appointments.length} citas médicas programadas.",
        );
      } else {
        notifications.add("No tienes citas médicas registradas.");
      }

      emit(HomeLoaded(notifications));
    } catch (e) {
      emit(HomeError("Error al cargar notificaciones: $e"));
    }
  }
}
