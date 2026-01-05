abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportPdfGenerated extends ReportState {
  final List<int> pdfBytes;
  ReportPdfGenerated(this.pdfBytes);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}
