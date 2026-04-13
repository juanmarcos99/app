import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment? appointment;

  const AppointmentCard({super.key, this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 2 : 4, // Menos elevación en dark para evitar que se vea gris muy claro
      color: isDark ? colorScheme.surfaceContainer : theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icono de calendario con contenedor tonal adaptativo
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // En Dark mode subimos la opacidad para que el color primario se note
                color: colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.event,
                color: isDark ? colorScheme.primary : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Texto de fecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fecha confirmada",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      // Usamos onSurfaceVariant para el texto secundario
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    "${appointment!.time!.day}/${appointment!.time!.month}/${appointment!.time!.year}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error),
              onPressed: () {
                context.read<AppointmentBloc>().add(
                      DeleteAppointmentEvent(appointment!),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}