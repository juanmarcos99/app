import 'package:app/features/diary/diary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetCrisesByMonthAndYearUseCase getCrisesByMonthAndYearUseCase;
  final GetAdverseEventsByMonthAndYearUseCase
  getAdverseEventsByMonthAndYearUseCase;
  final GeneratePdfUseCase generatePdfUseCase;

  ReportBloc({
    required this.getCrisesByMonthAndYearUseCase,
    required this.getAdverseEventsByMonthAndYearUseCase,
    required this.generatePdfUseCase,
  }) : super(ReportInitial()) {
    on<GenerateMonthlyReportEvent>((event, emit) async {
      emit(ReportLoading());

      try {
        final crises = await getCrisesByMonthAndYearUseCase(
          month: event.month,
          year: event.year,
          userId: event.userId,
        );

        final adverseEvents = await getAdverseEventsByMonthAndYearUseCase(
          month: event.month,
          year: event.year,
          userId: event.userId,
        );

        final pdfBytes = await generatePdfUseCase(
          crises: crises,
          adverseEvents: adverseEvents,
          fileName: event.fileName,
        );

        emit(ReportPdfGenerated(pdfBytes));
      } catch (e) {
        emit(ReportError("Error generando el reporte: $e"));
      }
    });
  }
}
