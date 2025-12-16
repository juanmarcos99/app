import 'package:flutter_bloc/flutter_bloc.dart';
import '../../diary.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final AddCrisis addCrisis;

  // Día seleccionado como atributo del Bloc
  DateTime? selectedDay;

  DiaryBloc(this.addCrisis) : super( DiaryInitial()) {
    on<DaySelectedEvent>((event, emit) {
      selectedDay = event.day;
      emit(DaySelected(event.day)); 
    });

    on<AddCrisisEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        await addCrisis(
          // puedes ajustar crisisDate en el use case o aquí
          event.crisis.copyWith(crisisDate: selectedDay ?? DateTime.now()),
        );
        emit(CrisisAdded());
      } catch (e) {
        emit(DiaryFailure(e.toString()));
      }
    });
  }
}