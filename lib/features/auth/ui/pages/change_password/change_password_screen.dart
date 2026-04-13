import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isNotEmpty(String s) => s.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthFailure || current is UserPasswordChanged,
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message, style: theme.textTheme.bodyMedium),
                backgroundColor: theme.colorScheme.error,
              ),
            );
        }

        if (state is UserPasswordChanged) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Contraseña cambiada correctamente"),
                backgroundColor: AppColors.success,
              ),
            );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ---------------- HERO SIN SAFEAREA ----------------
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/change_password.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                theme.colorScheme.surface,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,

                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),

                          color: Colors.white, // flecha blanca sobre la imagen
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cambiar Contraseña",
                              style: theme.textTheme.displayLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ingresa tu usuario y actualiza tu contraseña.",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- CONTENIDO CON SAFEAREA ----------------
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        CustomTextField(
                          label: "Usuario",
                          icon: Icons.person,
                          controller: _userController,
                        ),
                        const SizedBox(height: 30),

                        CustomTextField(
                          label: "Contraseña actual",
                          icon: Icons.lock_outline,
                          obscure: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 30),

                        CustomTextField(
                          label: "Nueva contraseña",
                          icon: Icons.lock_reset,
                          obscure: true,
                          controller: _newPasswordController,
                        ),
                        const SizedBox(height: 30),

                        CustomTextField(
                          label: "Confirmar nueva contraseña",
                          icon: Icons.lock_outline,
                          obscure: true,
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: 50),

                        PrimaryButton(
                          text: "Actualizar",
                          onPressed: () {
                            final user = _userController.text.trim();
                            final current = _passwordController.text.trim();
                            final newPass = _newPasswordController.text.trim();
                            final confirm = _confirmPasswordController.text
                                .trim();

                            if (!isNotEmpty(user) ||
                                !isNotEmpty(current) ||
                                !isNotEmpty(newPass) ||
                                !isNotEmpty(confirm)) {
                              _showError("Todos los campos son obligatorios");
                              return;
                            }

                            if (newPass != confirm) {
                              _showError("Las contraseñas no coinciden");
                              return;
                            }

                            context.read<AuthBloc>().add(
                              ChangePasswordEvent(user, current, newPass),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showError(String msg) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: theme.textTheme.bodyMedium),
          backgroundColor: theme.colorScheme.error,
        ),
      );
  }
}
