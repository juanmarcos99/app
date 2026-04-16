import 'package:flutter/material.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Usamos el color del tema para el fondo
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER EDITORIAL ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BIENVENIDO",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.primary,
                                letterSpacing: 2.0,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                String userName = "Invitado";
                                final authState = context
                                    .watch<AuthBloc>()
                                    .state;
                                if (authState is UserLoggedIn) {
                                  userName = authState.user.name;
                                }
                                return Text(
                                  userName,
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontSize: 36,
                                    height: 1.1,
                                  ),
                                );
                              },
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

                        // --- LISTA DE OPCIONES (Tonal Layering) ---
                        _SettingsTile(
                          icon: Icons.person,
                          title: 'Datos del perfil',
                          subtitle: 'Gestiona tu información personal',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.profileData,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          icon: Icons.notifications,
                          title: 'Notificaciones',
                          subtitle: 'Configura tus alertas y avisos',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.medicalAppointment,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          icon: Icons.picture_as_pdf,
                          title: 'Exportar reporte (PDF)',
                          subtitle: 'Descarga tus datos clínicos',
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.pdf),
                        ),

                        const SizedBox(height: 48),

                        // --- DANGER ZONE (Log Out) ---
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: colorScheme.error.withValues(
                                alpha: 0.08,
                              ),
                              foregroundColor: colorScheme.error,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.error.withValues(alpha:0.1),
                                ),
                              ),
                            ),
                            onPressed: () {
                              // Aquí podrías agregar la lógica de logout de tu AuthBloc
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.logout, size: 20),
                            label: const Text(
                              'Cerrar sesión',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Versión
                        Center(
                          child: Text(
                            "Versión 2.4.0 • Clinical Intelligence",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha:
                                0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        // Usamos surfaceContainerHighest definido en tu AppTheme
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: colorScheme.surfaceContainerHigh,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 18,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.outlineVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
