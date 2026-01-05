
abstract class ReportEvent {}

class GenerateMonthlyReportEvent extends ReportEvent {
  final int month;
  final int year;
  final int userId;
  final String fileName;
  GenerateMonthlyReportEvent({
    required this.month,
    required this.year,
    required this.userId,
    required this.fileName,
  });
}

class ResetReportEvent extends ReportEvent {}
