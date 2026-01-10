import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:app/features/diary/diary.dart';

class PdfGeneratorService {
  Future<List<int>> generateMonthlyReport({
    required List<Crisis> crises,
    required List<AdverseEvent> adverseEvents,
    required String fileName,
  }) async {
    final pdf = pw.Document();

    // ---------------------------
    // TABLA DE CRISIS
    // ---------------------------
    final crisisTable = pw.Table.fromTextArray(
      headers: ['Fecha', 'Horario', 'Tipo de crisis', 'Cantidad'],
      data: crises.map((c) {
        final date = c.crisisDate.toString().split(' ').first;
        final time = c.timeRange; // ← USAMOS EL RANGO REAL

        return [
          date,
          time,
          c.type,
          c.quantity.toString(),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 11),
      border: pw.TableBorder.all(color: PdfColors.grey600),
    );

    // ---------------------------
    // TABLA DE EVENTOS ADVERSOS
    // ---------------------------
    final adverseEventsTable = pw.Table.fromTextArray(
      headers: ['Fecha', 'Descripción'],
      data: adverseEvents.map((e) {
        final date = e.eventDate.toString().split(' ').first;
        return [
          date,
          e.description,
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 11),
      border: pw.TableBorder.all(color: PdfColors.grey600),
    );

    // ---------------------------
    // PÁGINA DEL PDF
    // ---------------------------
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Reporte mensual: $fileName",
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 20),

          pw.Text("Crisis registradas: ${crises.length}"),
          pw.SizedBox(height: 10),

          crisisTable,

          pw.SizedBox(height: 30),

          pw.Text("Eventos adversos: ${adverseEvents.length}"),
          pw.SizedBox(height: 10),

          adverseEventsTable,
        ],
      ),
    );

    return pdf.save();
  }
}
