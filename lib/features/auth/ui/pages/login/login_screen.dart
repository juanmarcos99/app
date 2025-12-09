import 'package:flutter/material.dart';
import 'package:app/features/auth/ui/auth_ui.dart'; // 👈 CustomTextField y PrimaryButton

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 👇 Contenido principal centrado
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
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        label: 'Usuario',
                        hint: '',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Contraseña',
                        hint: '',
                        icon: Icons.lock_outline,
                        obscure: true,
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
                      const SizedBox(height: 30),
                      PrimaryButton(text: 'Entrar', onPressed: () {}),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Bloque fijo al final
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
                    onTap: () {},
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
