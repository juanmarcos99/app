import 'package:app/features/diary/diary.dart';

abstract class PdfRepository {
  Future<List<int>> generateMonthlyReport({
    required List<Crisis> crises,
    required List<AdverseEvent> adverseEvents,
    required String fileName,
  });
}
