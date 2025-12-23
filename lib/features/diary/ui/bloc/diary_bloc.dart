import 'package:app/features/diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final AddCrisis addCrisis;
  final GetCrisesByDay getCrisesByDay;
  final GetCrisesDays getCrisesDays;
  final AddAdverseEvent addAdverseEvent;
  final GetAdverseAventByDayAndUser getAdverseAventByDayAndUser;
  final GetAdverseEventDaysByUser getAdverseEventDaysByUser;

  ///Atributo que guarda el día seleccionado
  DateTime daySelected = DateUtils.dateOnly(DateTime.now());

  DiaryBloc(
    this.addCrisis,
    this.getCrisesByDay,
    this.getCrisesDays,
    this.addAdverseEvent,
    this.getAdverseAventByDayAndUser,
    this.getAdverseEventDaysByUser,
  ) : super(DiaryInitial()) {
    // Evento para cambiar el día
    on<DayChangeEvent>((event, emit) {
      daySelected = DateUtils.dateOnly(event.newDay);
      emit(DayChangedState(daySelected));
    });

    // Evento para cargar el calendario
    on<LoadCalendarEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final crisisDays = (await getCrisesDays(event.userId)).toSet();
        final aeDays = (await getAdverseEventDaysByUser(event.userId)).toSet();
        emit(CalendarLoaded(crisisDays, aeDays));
      } catch (e) {
        emit(CalendarError(e.toString()));
      }
    });

    // Evento cargar las tarjetas
    on<LoadTarjetasEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final crises = await getCrisesByDay(
          DateUtils.dateOnly(event.date),
          event.userId,
        );
        final eventos = await getAdverseAventByDayAndUser(
          DateUtils.dateOnly(event.date),
          event.userId,
        );
        emit(TarjetasLoaded(crises, eventos));
      } catch (e) {
        emit(TarjetasError(e.toString()));
      }
    });

    //para añadir crisis
    on<AddCrisisEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        await addCrisis(event.crisis);
        emit(CrisisAdded(event.crisis));
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });

    //para añadir evento adverso
    on<AddAdverseEventEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        debugPrint("entro al add evento adverso");
        await addAdverseEvent(event.av);
        emit(AdverseEventAdded(event.av));
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });
  }
}
