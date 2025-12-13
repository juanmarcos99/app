import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/ui/diary_ui.dart';
import 'package:app/features/diary/domain/diary_domain.dart';


class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final RegisterCrisis registerCrisis;
  final GetAllCrisisByUser getAllCrisisByUser;

  // atributo interno para mantener el día seleccionado
  DateTime selectedDay = DateTime.now();

  DiaryBloc({
    required this.registerCrisis,
    required this.getAllCrisisByUser,
  }) : super(DiaryInitial()) {
    on<LoadCrisisEvent>(_onLoadCrisis);
    on<AddCrisisEvent>(_onAddCrisis);
    on<SelectDayEvent>(_onSelectDay);
  }

  Future<void> _onLoadCrisis(
      LoadCrisisEvent event, Emitter<DiaryState> emit) async {
    emit(DiaryLoading());
    try {
      final crises = await getAllCrisisByUser(event.userId);
      emit(DiaryLoaded(crises: crises, selectedDay: selectedDay));
    } catch (e) {
      emit(DiaryError("Error cargando crisis: $e"));
    }
  }

  Future<void> _onAddCrisis(
      AddCrisisEvent event, Emitter<DiaryState> emit) async {
    if (state is DiaryLoaded) {
      try {
        await registerCrisis(event.crisis); // guardar en BD
        final current = state as DiaryLoaded;
        final updated = List<Crisis>.from(current.crises)..add(event.crisis);

        // usamos el atributo selectedDay
        emit(DiaryLoaded(crises: updated, selectedDay: selectedDay));
      } catch (e) {
        emit(DiaryError("Error registrando crisis: $e"));
      }
    }
  }

  void _onSelectDay(SelectDayEvent event, Emitter<DiaryState> emit) {
    selectedDay = event.day; // actualizamos el atributo
    if (state is DiaryLoaded) {
      final current = state as DiaryLoaded;
      emit(DiaryLoaded(crises: current.crises, selectedDay: selectedDay));
    }
  }
}
