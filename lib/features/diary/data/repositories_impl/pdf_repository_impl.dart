import 'package:app/features/diary/diary.dart';

class PdfRepositoryImpl implements PdfRepository {
  final PdfGeneratorService pdfService;

  PdfRepositoryImpl(this.pdfService);

  @override
  Future<List<int>> generateMonthlyReport({
    required List<Crisis> crises,
    required List<AdverseEvent> adverseEvents,
    required String fileName,
  }) {
    return pdfService.generateMonthlyReport(
      crises: crises,
      adverseEvents: adverseEvents,
      fileName: fileName,
    );
  }
}
