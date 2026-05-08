import 'package:flutter/material.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/share/ui/widgets/settings_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
                                final authState = context.watch<AuthBloc>().state;
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
                                borderRadius: BorderRadius.circular(double.infinity),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        SettingsTile(
                          icon: Icons.person,
                          title: 'Datos del perfil',
                          subtitle: 'Gestiona tu información personal',
                          onTap: () => Navigator.pushNamed(context, '/profileData'),
                        ),
                        const SizedBox(height: 16),
                        SettingsTile(
                          icon: Icons.notifications,
                          title: 'Notificaciones',
                          subtitle: 'Configura tus alertas y avisos',
                          onTap: () => Navigator.pushNamed(context, '/medicalAppointment'),
                        ),
                        const SizedBox(height: 16),
                        SettingsTile(
                          icon: Icons.picture_as_pdf,
                          title: 'Exportar reporte (PDF)',
                          subtitle: 'Descarga tus datos clínicos',
                          onTap: () => Navigator.pushNamed(context, '/pdf'),
                        ),
                        const SizedBox(height: 16),
                        SettingsTile(
                          icon: Icons.qr_code,
                          title: 'Compartir QR',
                          subtitle: 'Compartir datos clínicos',
                          onTap: () => Navigator.pushNamed(context, '/qr'),
                        ),
                        if (context.watch<AuthBloc>().state is UserLoggedIn && (context.watch<AuthBloc>().state as UserLoggedIn).user.role == 'doctor') ...[
                          const SizedBox(height: 16),
                          SettingsTile(
                            icon: Icons.qr_code_scanner,
                            title: 'Escanear código de paciente',
                            subtitle: 'Vincular un nuevo paciente a tu lista',
                            onTap: () async {
                              final result = await Navigator.pushNamed(context, AppRoutes.scannerPage);
                            },
                          ),
                        ],
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: colorScheme.error.withValues(alpha: 0.08),
                              foregroundColor: colorScheme.error,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.error.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.logout, size: 20),
                            label: const Text(
                              'Cerrar sesión',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            "v1.0.0",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
