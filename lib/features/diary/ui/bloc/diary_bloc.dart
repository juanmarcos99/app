import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final AddCrisis addCrisis;
  final GetCrisesByDay getCrisesByDay;

  ///Atributo que guarda el día seleccionado
  DateTime daySelected = DateUtils.dateOnly(DateTime.now());

  DiaryBloc(this.addCrisis, this.getCrisesByDay) : super(DiaryInitial()) {
    // Evento para cambiar el día
    on<DayChangeEvent>((event, emit) {
      // Normalizamos al inicio del día
      daySelected = DateUtils.dateOnly(event.newDay);
      emit(DayChangedState(daySelected));
    });

    // Evento cargar las tarjetas
    on<LoadTarjetasEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final crises = await getCrisesByDay(DateUtils.dateOnly(event.date), event.userId);
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
        debugPrint("entro al bloc");
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });
  }
}
