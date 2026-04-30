import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/share/ui/widgets/settings_tile.dart';
import 'package:app/app_routes.dart';

class OpcionsDoctor extends StatelessWidget {
  const OpcionsDoctor({super.key});

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
                        // Header
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BIENVENIDO',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.primary,
                                letterSpacing: 2.0,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                String userName = 'Doctor';
                                final authState =
                                    context.watch<AuthBloc>().state;
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

                        // Tiles
                        SettingsTile(
                          icon: Icons.person,
                          title: 'Datos del perfil',
                          subtitle: 'Gestiona tu información personal',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.profileDoctor,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Cerrar sesión
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
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              );
                            },
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
                            'v1.0.0',
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
