import 'package:flutter/material.dart';
import 'package:app/core/share/ui/widgets/settings_tile.dart';
import 'package:app/app_routes.dart';

class PacienteInformation extends StatelessWidget {
  final dynamic patient;

  const PacienteInformation({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${patient.name} ${patient.lastName}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PACIENTE',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          letterSpacing: 2.0,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient.name} ${patient.lastName}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 36,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 4,
                        width: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                            double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Diario del paciente tile
                  SettingsTile(
                    icon: Icons.book_outlined,
                    title: 'Diario del paciente',
                    subtitle:
                        'Dar seguimiento al paciente',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.patientDiary,
                        arguments: patient,
                      );
                    },
                  ),
                  // Aquí se añadirán más botones en futuras iteraciones
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
