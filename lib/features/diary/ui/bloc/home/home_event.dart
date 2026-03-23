import 'package:equatable/equatable.dart';


abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar las notificaciones del usuario
class LoadNotificationsEvent extends HomeEvent {
  final int userId;

  const LoadNotificationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
