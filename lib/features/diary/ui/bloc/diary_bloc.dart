import 'package:app/features/diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final AddCrisis addCrisis;
  final GetCrisesByDay getCrisesByDay;
  final GetCrisesDays getCrisesDays;

  ///Atributo que guarda el día seleccionado
  DateTime daySelected = DateUtils.dateOnly(DateTime.now());

  DiaryBloc(this.addCrisis, this.getCrisesByDay, this.getCrisesDays)
    : super(DiaryInitial()) {
    // Evento para cambiar el día
    on<DayChangeEvent>((event, emit) {
      // Normalizamos al inicio del día
      daySelected = DateUtils.dateOnly(event.newDay);
      emit(DayChangedState(daySelected));
    });
    // Evento para cargar el calendario
    on<LoadCalendarEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        //Aquí llamas al repositorio para obtener los días con crisis
        final crisisDays = (await getCrisesDays(event.userId)).toSet();
        emit(CalendarLoaded(crisisDays));
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
        debugPrint("Crisis cargadas:");
        emit(TarjetasLoaded(crises));
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
  }
}
