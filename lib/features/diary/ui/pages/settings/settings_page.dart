import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundLight = Color(0xFFF6F7F8);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Contenido scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Encabezado del perfil
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar con icono Flutter
                            Container(
                              height: 112,
                              width: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryLight,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 4,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 70,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Builder(
                              builder: (context) {
                                String user = "";
                                final authState = context.read<AuthBloc>().state;
                                if (authState is UserLoggedIn) {
                                  user = authState.user.name;
                                }
                                return Text(
                                  user.isNotEmpty ? user : "Invitado",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Lista de opciones
                        Column(
                          children: [
                            _SettingsTile(
                              icon: Icons.person,
                              iconColor: AppColors.primary,
                              title: 'Datos del perfil',
                              subtitle: 'Gestiona tu información personal',
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),

                            _SettingsTile(
                              icon: Icons.notifications,
                              iconColor: AppColors.primary,
                              title: 'Notificaciones',
                              subtitle: 'Personaliza tus alertas',
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),

                            _SettingsTile(
                              icon: Icons.description,
                              iconColor: AppColors.primary,
                              title: 'Exportar reporte (PDF)',
                              subtitle: 'Descargar resumen de salud',
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.pdf);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Botón cerrar sesión
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade500,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              overlayColor: Colors.red.shade50.withValues(alpha:0.3),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
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
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Colors.grey.shade50;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
