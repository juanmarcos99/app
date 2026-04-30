import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/diary.dart';
import 'package:equatable/equatable.dart';
import 'package:app/features/diary/domain/use_cases/get_remote_crises_usecase.dart';
import 'package:app/features/diary/domain/use_cases/get_remote_adverse_events_usecase.dart';

// EVENTS
abstract class PatientDiaryEvent extends Equatable {
  const PatientDiaryEvent();
  @override
  List<Object?> get props => [];
}

class LoadPatientCalendarEvent extends PatientDiaryEvent {
  final int userId;
  const LoadPatientCalendarEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class LoadPatientTarjetasEvent extends PatientDiaryEvent {
  final int userId;
  final DateTime date;
  const LoadPatientTarjetasEvent({required this.userId, required this.date});
  @override
  List<Object?> get props => [userId, date];
}

class SelectPatientDayEvent extends PatientDiaryEvent {
  final DateTime day;
  const SelectPatientDayEvent(this.day);
  @override
  List<Object?> get props => [day];
}

// STATES
abstract class PatientDiaryState extends Equatable {
  const PatientDiaryState();
  @override
  List<Object?> get props => [];
}

class PatientDiaryInitial extends PatientDiaryState {}

class PatientDiaryLoading extends PatientDiaryState {}

class PatientCalendarLoaded extends PatientDiaryState {
  final List<DateTime> crisisDays;
  final List<DateTime> aeDays;
  const PatientCalendarLoaded({
    required this.crisisDays,
    required this.aeDays,
  });
  @override
  List<Object?> get props => [crisisDays, aeDays];
}

class PatientTarjetasLoaded extends PatientDiaryState {
  final List<Crisis> crises;
  final List<AdverseEvent> ae;
  const PatientTarjetasLoaded({required this.crises, required this.ae});
  @override
  List<Object?> get props => [crises, ae];
}

class PatientDiaryError extends PatientDiaryState {
  final String message;
  const PatientDiaryError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class PatientDiaryBloc extends Bloc<PatientDiaryEvent, PatientDiaryState> {
  final GetRemoteCrisesByDayAndUserUseCase getCrisesByDayAndUser;
  final GetRemoteCrisesDaysByUserUseCase getCrisesDaysByUser;
  final GetRemoteAdverseEventsByDayAndUserUseCase getAdverseEventByDayAndUser;
  final GetRemoteAdverseEventsDaysByUserUseCase getAdverseEventDaysByUser;

  DateTime _daySelected = DateTime.now();
  DateTime get daySelected => _daySelected;

  PatientDiaryBloc({
    required this.getCrisesByDayAndUser,
    required this.getCrisesDaysByUser,
    required this.getAdverseEventByDayAndUser,
    required this.getAdverseEventDaysByUser,
  }) : super(PatientDiaryInitial()) {
    on<LoadPatientCalendarEvent>(_onLoadPatientCalendar);
    on<LoadPatientTarjetasEvent>(_onLoadPatientTarjetas);
    on<SelectPatientDayEvent>(_onSelectPatientDay);
  }

  Future<void> _onLoadPatientCalendar(
    LoadPatientCalendarEvent event,
    Emitter<PatientDiaryState> emit,
  ) async {
    emit(PatientDiaryLoading());
    try {
      final crisisDays = await getCrisesDaysByUser(event.userId);
      final eventDays = await getAdverseEventDaysByUser(event.userId);

      emit(PatientCalendarLoaded(crisisDays: crisisDays, aeDays: eventDays));
    } catch (e) {
      emit(PatientDiaryError("Error al cargar días del paciente: $e"));
    }
  }

  Future<void> _onLoadPatientTarjetas(
    LoadPatientTarjetasEvent event,
    Emitter<PatientDiaryState> emit,
  ) async {
    emit(PatientDiaryLoading());
    try {
      final cr = await getCrisesByDayAndUser(event.date, event.userId);
      final ev = await getAdverseEventByDayAndUser(event.date, event.userId);

      emit(PatientTarjetasLoaded(crises: cr, ae: ev));
    } catch (e) {
      emit(PatientDiaryError("Error al cargar registros del paciente: $e"));
    }
  }

  void _onSelectPatientDay(
    SelectPatientDayEvent event,
    Emitter<PatientDiaryState> emit,
  ) {
    _daySelected = event.day;
  }
}
