import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPendingSyncTasksByUserIdUseCase getPendingSyncTasksUserIdUseCase;
  HomeBloc({required this.getPendingSyncTasksUserIdUseCase}) : super(HomeInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // 1. Llamada al repositorio usando tu nueva entidad filtrada por userId
      final List<SyncTask> tasks = await getPendingSyncTasksUserIdUseCase(
        event.userId,
      );

      if (tasks.isEmpty) {
        emit(const HomeLoaded([]));
        return;
      }

      // 2. Transformación a mensajes para la UI
      final List<String> notifications = tasks.map((task) {
        final String action = _getFriendlyAction(task.method);
        final String entity = _getFriendlyEndpoint(task.endpoint);

        return "$action de $entity";
      }).toList();

      emit(HomeLoaded(notifications));
    } catch (e) {
      emit(HomeError("Error al sincronizar notificaciones: $e"));
    }
  }

  // Helpers para que los mensajes no sean técnicos (INSERT, users, etc)
  String _getFriendlyAction(String method) {
    switch (method.toUpperCase()) {
      case 'INSERT':
        return 'Creación';
      case 'UPDATE':
        return 'Actualización';
      case 'DELETE':
        return 'Eliminación';
      default:
        return 'Cambio';
    }
  }

  String _getFriendlyEndpoint(String endpoint) {
    switch (endpoint.toLowerCase()) {
      case 'users':
        return 'perfil';
      case 'crisis':
        return 'registro de crisis';
      case 'medications':
        return 'medicamento';
      case 'appointments':
        return 'cita médica';
      default:
        return endpoint;
    }
  }
}
