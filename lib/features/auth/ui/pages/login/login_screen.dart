import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  List<String> rememberedUsers = [];

  TextEditingController? autocompleteController;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadRememberedUsersEvent());
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // Quita el foco de cualquier campo activo
            FocusScope.of(context).unfocus();
          },
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthFailure ||
                current is UserLoggedIn ||
                current is RememberUsersLoaded ||
                current is PasswordLoaded,
            listener: (context, state) {
              if (state is AuthFailure) {
                AppSnack.show(context, state.message, color: AppColors.error);
              }
              if (state is UserLoggedIn) {
                usernameController.clear();
                autocompleteController?.clear();
                passwordController.clear();
                AppSnack.show(
                  context,
                  "Bienvenido ${state.user.userName}",
                  color: AppColors.success,
                );
                Navigator.pushNamed(context, AppRoutes.mainNavigationPage);
              }
              if (state is RememberUsersLoaded) {
                setState(() {
                  rememberedUsers = state.users;
                });
              }
              if (state is PasswordLoaded) {
                passwordController.text = state.password;
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Iniciar Sesión",
                              style: AppTypography.headline1Light,
                            ),
                            const SizedBox(height: 30),
                            Image.asset(
                              'assets/images/login.png',
                              height: 240,
                              width: 320,
                            ),
                            const SizedBox(height: 5),

                            Autocomplete<String>(
                              optionsBuilder: (TextEditingValue value) {
                                if (value.text.isEmpty) return rememberedUsers;
                                return rememberedUsers.where(
                                  (u) => u.toLowerCase().contains(
                                    value.text.toLowerCase(),
                                  ),
                                );
                              },
                              onSelected: (username) {
                                usernameController.text = username;
                                context.read<AuthBloc>().add(
                                  LoadPasswordEvent(username),
                                );
                              },
                              fieldViewBuilder: (
                                context,
                                controller,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                autocompleteController = controller;
                                return CustomTextField(
                                  label: 'Usuario',
                                  icon: Icons.person_outline,
                                  controller: controller,
                                  focusNode: focusNode,
                                  onFieldSubmitted: onFieldSubmitted,
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            CustomTextField(
                              label: 'Contraseña',
                              hint: '',
                              icon: Icons.lock_outline,
                              obscure: true,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberMe,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          rememberMe = value ?? false;
                                        });
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    const Text(
                                      "Recordarme",
                                      style: AppTypography.captionLight,
                                    ),
                                  ],
                                ),
                                LetterNavButton(
                                  letter: "¿Olvidaste tu contraseña?",
                                  onTap: () {},
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),

                            const SizedBox(height: 59),

                            PrimaryButton(
                              text: 'Entrar',
                              onPressed: () {
                                if (autocompleteController != null) {
                                  usernameController.text =
                                      autocompleteController!.text.trim();
                                }
                                final username =
                                    usernameController.text.trim();
                                final password =
                                    passwordController.text.trim();
                                context.read<AuthBloc>().add(
                                  LoginUserEvent(username, password, rememberMe),
                                );
                              },
                            ),

                            const SizedBox(height: 25),

                            LetterNavButton(
                              letter: "Cambiar contraseña",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.changePassword,
                                );
                              },
                              fontSize: 13,
                              color: AppColors.error,
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Aún no tienes cuenta?",
                          style: AppTypography.captionLight,
                        ),
                        LetterNavButton(
                          letter: "Registrarse",
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
