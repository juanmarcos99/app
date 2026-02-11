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

    String mapExactRange(String input) {
      final s = input.trim().toLowerCase();

      if (s == '6:00 am - 10:00 am') return '6am-10am';
      if (s == '10:00 am - 2:00 pm') return '10am-2pm';
      if (s == '2:00 pm - 6:00 pm') return '2pm-6pm';
      if (s == '6:00 pm - 10:00 pm') return '6pm-10pm';
      if (s == '10:00 pm - 6:00 am') return '10pm-6am';

      return input; // fallback
    }

    //  MAPEADOR DE TIPOS REALES → FC, FI, TB, OT

    String mapType(String type) {
      final t = type.trim().toLowerCase();
      if (t.contains('focales') && t.contains('inconsc')) {
        return 'FI'; // Focales inconscientes
      }
      if (t.contains('focales') && t.contains('consc')) {
        return 'FC'; // Focales conscientes
      }

      if (t.contains('tónico') ||
          t.contains('tonico') ||
          t.contains('clónico') ||
          t.contains('clonico') ||
          t.contains('bilateral')) {
        return 'TB'; // Tónico-clónico bilateral
      }

      // Cualquier otro texto (Añadir otro tipo, etc.)
      return 'OT';
    }

    final List<String> timeTypeRows = [
      '6am-10am / FC',
      '6am-10am / FI',
      '6am-10am / TB',
      '6am-10am / OT',
      '10am-2pm / FC',
      '10am-2pm / FI',
      '10am-2pm / TB',
      '10am-2pm / OT',
      '2pm-6pm / FC',
      '2pm-6pm / FI',
      '2pm-6pm / TB',
      '2pm-6pm / OT',
      '6pm-10pm / FC',
      '6pm-10pm / FI',
      '6pm-10pm / TB',
      '6pm-10pm / OT',
      '10pm-6am / FC',
      '10pm-6am / FI',
      '10pm-6am / TB',
      '10pm-6am / OT',
    ];

    // Normalizamos para comparación
    final normalizedRows = timeTypeRows
        .map((e) => e.toLowerCase().replaceAll(' ', ''))
        .toList();

    // MATRIZ VACÍA 20 filas × 31 día
    final crisisMatrix = List<List<String>>.generate(
      timeTypeRows.length,
      (_) => List<String>.filled(31, '', growable: false),
    );

    // LLENAR MATRIZ CON ASTERISCOS + DEBUG

    for (final c in crises) {
      if (c.crisisDate == null) continue;

      final day = c.crisisDate!.day;
      if (day < 1 || day > 31) continue;

      final mappedRange = mapExactRange(c.timeRange ?? '');
      final mappedType = mapType(c.type ?? '');
      final key = '$mappedRange / $mappedType';
      final normalizedKey = key.toLowerCase().replaceAll(' ', '');

      final rowIndex = normalizedRows.indexOf(normalizedKey);

      if (rowIndex == -1) {
        continue;
      }

      final marks = (c.quantity ?? 0).toString();
      crisisMatrix[rowIndex][day - 1] = marks;
    }

    //  TABLA MENSUAL DE CRISIS COMPATA
    final crisisTable = pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.3),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        // Encabezao
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Text(
                'Hora/Tipo',
                style: pw.TextStyle(
                  fontSize: 7,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            for (int i = 1; i <= 31; i++)
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  '$i',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),

        // Filas
        for (int r = 0; r < timeTypeRows.length; r++)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  timeTypeRows[r],
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ),
              for (int d = 0; d < 31; d++)
                pw.Container(
                  padding: const pw.EdgeInsets.all(1),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    crisisMatrix[r][d],
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
            ],
          ),
      ],
    );

    //  TABLA DE EVENTOS ADVERSOS

    final adverseEventsTable = pw.TableHelper.fromTextArray(
      headers: ['Fecha', 'Descripción'],
      data: adverseEvents.map((e) {
        final date = e.eventDate.toString().split(' ').first;
        return [date, e.description];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.3),
      cellAlignment: pw.Alignment.centerLeft,
    );

    // PÁGINA DEL PDF

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Text(
            "Reporte mensual: $fileName",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 10),

          pw.Text(
            "Registro mensual de crisis",
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 8),

          crisisTable,

          pw.SizedBox(height: 20),

          pw.Text(
            "Eventos adversos: ${adverseEvents.length}",
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 8),

          adverseEventsTable,
        ],
      ),
    );

    return pdf.save();
  }
}
