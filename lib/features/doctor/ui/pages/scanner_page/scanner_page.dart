import 'package:app/core/share/ui/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../bloc/scan_patient_BLoc/scan_patient_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/core/theme/style/colors.dart';

class ScannerPage extends StatefulWidget {
  final VoidCallback? onScanSuccess;

  const ScannerPage({super.key, this.onScanSuccess});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isScanCompleted = false;
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _processScan(int patientId) {
    if (_isScanCompleted) return;
    setState(() {
      _isScanCompleted = true;
    });
    context.read<ScanPatientBloc>().add(PatientScanned(patientId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<ScanPatientBloc, ScanPatientState>(
      listener: (context, state) {
        if (state is ScanPatientSuccess) {
          AppSnack.show(
            context,
            "Paciente vinculado correctamente (ID: ${state.patientId})",
            color: AppColors.success,
          );
          _idController.clear();
          setState(() {
            _isScanCompleted = false;
          });
          if (widget.onScanSuccess != null) {
            widget.onScanSuccess!();
          } else {
            Navigator.pop(context, true);
          }
        } else if (state is ScanPatientError) {
          AppSnack.show(context, state.message, color: AppColors.error);
          setState(() {
            _isScanCompleted = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "ESCANEAR PACIENTE",
            style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: cs.onSurface),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Escanea el código QR de un paciente para agregarlo a tu listado de pacientes",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.primary, width: 4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                          facing: CameraFacing.back,
                        ),
                        onDetect: (capture) {
                          if (_isScanCompleted) return;
                          final List<Barcode> barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            final String? code = barcode.rawValue;
                            if (code != null) {
                              final int? patientId = int.tryParse(code);
                              if (patientId != null) {
                                _processScan(patientId);
                                break;
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  "o añade su identificador manualmente",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _idController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: cs.onSurface),
                        decoration: InputDecoration(
                          hintText: "ID del paciente",
                          hintStyle: TextStyle(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.darkSurfaceSoft.withValues(alpha: 0.3)
                              : AppColors.surfaceSoft.withValues(alpha: 0.2),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: cs.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: cs.outline.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final text = _idController.text.trim();
                        if (text.isEmpty) return;
                        final patientId = int.tryParse(text);
                        if (patientId != null) {
                          _processScan(patientId);
                        } else {
                          AppSnack.show(
                            context,
                            "ID no válido",
                            color: AppColors.error,
                          );
                        }
                      },
                      child: const Text(
                        "Añadir",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
