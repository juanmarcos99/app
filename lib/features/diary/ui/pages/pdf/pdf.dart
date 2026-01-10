import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/features/auth/auth.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class ExportPdfPage extends StatefulWidget {
  const ExportPdfPage({super.key});

  @override
  State<ExportPdfPage> createState() => _ExportPdfPageState();
}

class _ExportPdfPageState extends State<ExportPdfPage> {
  String? selectedMonth;
  String? selectedYear;
  final TextEditingController pdfNameController = TextEditingController();

  List<FileSystemEntity> generatedPdfs = [];

  final List<String> months = const [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
  ];

  late final List<String> years;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    years = List.generate(6, (i) => (currentYear - i).toString());
    loadGeneratedPdfs();
  }

  Future<void> loadGeneratedPdfs() async {
    final dir = Directory('/storage/emulated/0/Download');
    final files = dir.listSync().where((f) => f.path.endsWith(".pdf")).toList();

    setState(() => generatedPdfs = files);
  }

  Future<String> savePdfToDownloads(List<int> bytes, String fileName) async {
    await Permission.storage.request();

    Directory directory = Directory('/storage/emulated/0/Download');
    final file = File('${directory.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) async {
        if (state is ReportLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is ReportPdfGenerated) {
          Navigator.pop(context);

          final savedPath = await savePdfToDownloads(
            state.pdfBytes,
            pdfNameController.text.trim(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("PDF guardado en: $savedPath")),
          );

          await loadGeneratedPdfs();
          await OpenFilex.open(savedPath);
        }

        if (state is ReportError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ENCABEZADO
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Exportar reporte",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secundary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 42),
                      ],
                    ),
                  ),

                  // CONTENIDO
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Exportar reporte en PDF",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secundary,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // FORMULARIO
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "Mes",
                                  value: selectedMonth,
                                  items: months,
                                  onChanged: (v) =>
                                      setState(() => selectedMonth = v),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdownField(
                                  label: "Año",
                                  value: selectedYear,
                                  items: years,
                                  onChanged: (v) =>
                                      setState(() => selectedYear = v),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            "Nombre del archivo PDF",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secundary,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: pdfNameController,
                            decoration: InputDecoration(
                              hintText: "Escribe el nombre del archivo",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // LISTA DE PDFs GENERADOS
                          const Text(
                            "PDFs generados",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secundary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...generatedPdfs.map((file) {
                            final name = file.path.split('/').last;
                            return PdfCard(
                              fileName: name,
                              onOpen: () => OpenFilex.open(file.path),
                              onShare: () async {
                                await Share.shareXFiles([
                                  XFile(file.path),
                                ], text: "Aquí tienes tu reporte en PDF");
                              },
                              onDelete: () {
                                File(file.path).deleteSync();
                                loadGeneratedPdfs();
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

                  // BOTÓN GENERAR PDF
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedMonth == null || selectedYear == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Selecciona mes y año"),
                              ),
                            );
                            return;
                          }

                          if (pdfNameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Ingresa un nombre"),
                              ),
                            );
                            return;
                          }

                          final monthIndex = months.indexOf(selectedMonth!) + 1;
                          final yearInt = int.parse(selectedYear!);

                          int userId = -1;
                          final authState = context.read<AuthBloc>().state;
                          if (authState is UserLoggedIn) {
                            userId = authState.user.id!;
                          }

                          context.read<ReportBloc>().add(
                            GenerateMonthlyReportEvent(
                              month: monthIndex,
                              year: yearInt,
                              userId: userId,
                              fileName: pdfNameController.text.trim(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Generar PDF",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.secundary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: const Text("Seleccionar"),
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.expand_more),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
