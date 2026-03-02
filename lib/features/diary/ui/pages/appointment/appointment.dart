import 'package:app/core/share/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';
import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';

class MedicalAppointmentPage extends StatelessWidget {
  const MedicalAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Headline
            const Text(
              "Selecciona el día de tu\nturno médico",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Elige una fecha disponible para tu consulta",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Botón agendar turno
            Center(
              child: PrimaryButton(
                text: "Agendar",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AppointmentDialog(
                      onConfirm: (date, desc) {
                        // lógica futura
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Contenedor invisible scrollable para las cards
            Expanded(
              child: ListView(
                children: [
                  // Ejemplo visual de cards
                  AppointmentCard(date: DateTime(2026, 5, 24)),
                  AppointmentCard(date: DateTime(2026, 6, 10)),
                  AppointmentCard(date: DateTime(2026, 7, 2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
