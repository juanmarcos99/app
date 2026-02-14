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
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthFailure || current is UserPasswordChanged,
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: AppTypography.captionDark,
                ),
                backgroundColor: AppColors.error,
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
          backgroundColor: AppColors.white,
          appBar: AppBar(title: const Text("Cambiar contraseña")),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Ingresa tu usuario y actualiza tu contraseña.",
                    style: AppTypography.bodyLight,
                  ),
                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "Usuario",
                    icon: Icons.person,
                    controller: _userController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Contraseña actual",
                    icon: Icons.lock_outline,
                    obscure: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Nueva contraseña",
                    icon: Icons.lock_reset,
                    obscure: true,
                    controller: _newPasswordController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Confirmar nueva contraseña",
                    icon: Icons.lock_outline,
                    obscure: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: PrimaryButton(
                      text: "Actualizar",
                      onPressed: () {
                        final user = _userController.text.trim();
                        final current = _passwordController.text.trim();
                        final newPass = _newPasswordController.text.trim();
                        final confirm = _confirmPasswordController.text.trim();

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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: AppTypography.captionDark),
          backgroundColor: AppColors.error,
        ),
      );
  }
}
