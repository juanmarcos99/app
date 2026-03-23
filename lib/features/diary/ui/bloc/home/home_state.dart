import 'package:equatable/equatable.dart';

/// Estados para el HomeBloc (notificaciones)
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class HomeInitial extends HomeState {}

/// Estado mientras se cargan las notificaciones
class HomeLoading extends HomeState {}

/// Estado cuando las notificaciones ya están listas
class HomeLoaded extends HomeState {
  final List<String> notifications;

  const HomeLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Estado cuando ocurre un error
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
