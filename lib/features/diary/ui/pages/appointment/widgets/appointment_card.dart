import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class AppointmentCard extends StatelessWidget {
  final DateTime date;

  const AppointmentCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icono de calendario
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.event, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),

            // Texto de fecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fecha confirmada",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    "${date.day}/${date.month}/${date.year}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Icono de basura (sin lógica aún)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () {
                // Aquí luego integras la lógica de borrado
              },
            ),
          ],
        ),
      ),
    );
  }
}
