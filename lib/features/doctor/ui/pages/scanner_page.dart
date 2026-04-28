import 'package:app/core/share/ui/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../bloc/scan_patient_bloc.dart';
import 'package:app/core/core.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isScanCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return BlocListener<ScanPatientBloc, ScanPatientState>(
      listener: (context, state) {
        if (state is ScanPatientSuccess) {
          AppSnack.show(
            context,
            "Paciente vinculado correctamente (ID: ${state.patientId})",
            color: AppColors.success,
          );
          Navigator.pop(context, true);
        } else if (state is ScanPatientError) {
          AppSnack.show(context, state.message, color: AppColors.error);
          setState(() {
            _isScanCompleted = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ESCANEAR PACIENTE"),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Stack(
          children: [
            MobileScanner(
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
                      setState(() {
                        _isScanCompleted = true;
                      });
                      context.read<ScanPatientBloc>().add(PatientScanned(patientId));
                      break;
                    }
                  }
                }
              },
            ),
            // Scanner Overlay
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: cs.primary, width: 4),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Text(
                "Enfoca el código QR del paciente",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  backgroundColor: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
