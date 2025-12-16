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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              current is AuthFailure || current is UserLoggedIn,
          listener: (context, state) {
            print("🔎 Listener recibió estado: $state");

            if (state is AuthFailure) {
              print("❌ Error de login: ${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is UserLoggedIn) {
              print("✅ Usuario logueado: ${state.user.userName}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Bienvenido ${state.user.userName}"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushNamed(context, AppRoutes.diary);
            }
          },
          builder: (context, state) {
            print("🎨 Builder dibujando con estado: $state");

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Image.asset(
                            'assets/images/login.png',
                            height: 240,
                            width: 320,
                          ),
                          const SizedBox(height: 5),
                          CustomTextField(
                            label: 'Usuario',
                            hint: '',
                            icon: Icons.person_outline,
                            controller: usernameController,
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              LetterNavButton(
                                letter: "Olvidaste tu contraseña?",
                                onTap: () {},
                                fontSize: 13,
                              ),
                            ],
                          ),
                          const SizedBox(height: 59),
                          PrimaryButton(
                            text: 'Entrar',
                            onPressed: () {
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              print("🚀 Botón Entrar presionado con usuario=$username, password=$password");

                              context.read<AuthBloc>().add(
                                LoginUserEvent(username, password),
                              );
                              print("📤 Evento LoginUserEvent enviado al AuthBloc");
                            },
                          ),
                          const SizedBox(height: 25),
                          LetterNavButton(
                            letter: "Cambiar contraseña",
                            onTap: () {},
                            fontSize: 13,
                            color: const Color.fromARGB(255, 255, 55, 135),
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
                      const Text(
                        "Aun no tienes cuenta?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      LetterNavButton(
                        letter: "Registrarse",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
