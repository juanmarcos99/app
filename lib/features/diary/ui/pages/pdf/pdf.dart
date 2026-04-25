import 'dart:io';
import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    try {
        final dir = Directory('/storage/emulated/0/Download');
    if (await dir.exists()) {
      final files = dir
          .listSync()
          .where((f) => f.path.endsWith(".pdf"))
          .toList();
      setState(() => generatedPdfs = files);
    }
    } catch (e) {
      debugPrint(e.toString());
    }
  
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) async {
        if (state is ReportLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
          );
        }

        if (state is ReportPdfGenerated) {
          Navigator.pop(context);
          final savedPath = await savePdfToDownloads(
            state.pdfBytes,
            pdfNameController.text.trim(),
          );
          AppSnack.show(context, "PDF guardado en: $savedPath");
          await loadGeneratedPdfs();
          await OpenFilex.open(savedPath);
        }

        if (state is ReportError) {
          Navigator.pop(context);
          AppSnack.show(context, state.message, color: AppColors.error);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/pdf.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(69, 0, 0, 0),
                              colorScheme.surface,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Exportar reporte",
                            style: theme.textTheme.displayLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Genera un documento PDF con tu historial médico mensual.",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
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
                      CustomTextField(
                        label: 'Nombre del archivo PDF',
                        hint: 'Ej. Reporte_Abril_2026',
                        icon: Icons.description_outlined,
                        obscure: false,
                        controller: pdfNameController,
                      ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: "Generar PDF",
                        onPressed: _onGeneratePdf,
                      ),
                      const SizedBox(height: 40),
                      if (generatedPdfs.isNotEmpty) ...[
                        Text(
                          "Documentos generados",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...generatedPdfs.map((file) {
                          final name = file.path.split('/').last;
                          return PdfCard(
                            fileName: name,
                            onOpen: () => OpenFilex.open(file.path),
                            onShare: () async {
                              // ignore: deprecated_member_use
                              await Share.shareXFiles([
                                XFile(file.path),
                              ], text: 'Aquí tienes tu reporte médico');
                            },
                            onDelete: () {
                              File(file.path).deleteSync();
                              loadGeneratedPdfs();
                            },
                          );
                        }),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGeneratePdf() {
    if (selectedMonth == null ||
        selectedYear == null ||
        pdfNameController.text.trim().isEmpty) {
      AppSnack.show(
        context,
        "Completa todos los campos",
        color: AppColors.error,
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
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: const Text("Seleccionar"),
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.primary),
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
