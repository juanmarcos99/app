import 'package:app/features/diary/diary.dart';

class GeneratePdfUseCase {
  final PdfRepository repository;

  GeneratePdfUseCase(this.repository);

  Future<List<int>> call({
    required List<Crisis> crises,
    required List<AdverseEvent> adverseEvents,
    required String fileName,
  }) {
    return repository.generateMonthlyReport(
      crises: crises,
      adverseEvents: adverseEvents,
      fileName: fileName,
    );
  }
}
