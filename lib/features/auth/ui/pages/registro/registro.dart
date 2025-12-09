import 'package:flutter/material.dart';
import 'package:app/features/auth/ui/auth_ui.dart'; // aquí está tu CustomTextField

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  String? selectedRole; // 👈 empieza en null (ninguno seleccionado)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "Crear Cuenta",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 3, bottom: 50),
                child: Text(
                  "Rellena los campos y créate una cuenta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const CustomTextField(
                label: 'Nombre',
                hint: '', // 👈 cadena vacía
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Apellidos',
                hint: '',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Teléfono',
                hint: '',
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Correo',
                hint: '',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Usuario',
                hint: '',
                icon: Icons.person_2_outlined,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Contraseña',
                hint: '',
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 30),

              // 👇 Radios uno al lado del otro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: "Paciente",
                        groupValue: selectedRole,
                        activeColor: Colors.red.shade900,
                        onChanged: (val) {
                          setState(() => selectedRole = val);
                        },
                      ),
                      Text(
                        "Paciente",
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Row(
                    children: [
                      Radio<String>(
                        value: "Doctor",
                        groupValue: selectedRole,
                        activeColor: Colors.blue.shade900,
                        onChanged: (val) {
                          setState(() => selectedRole = val);
                        },
                      ),
                      Text(
                        "Doctor",
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 👇 Campos condicionales según selección
              if (selectedRole == "Doctor") ...[
                const CustomTextField(
                  label: 'Código',
                  hint: '',
                  icon: Icons.vpn_key_outlined,
                ),
              ] else if (selectedRole == "Paciente") ...[
                const CustomTextField(
                  label: 'Teléfono del cuidador',
                  hint: '',
                  icon: Icons.phone_forwarded_outlined,
                ),
                const SizedBox(height: 20),
                const CustomTextField(
                  label: 'Correo del cuidador',
                  hint: '',
                  icon: Icons.alternate_email_outlined,
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 35),
                child: PrimaryButton(text: 'Registrarse', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
