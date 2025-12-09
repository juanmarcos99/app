import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart'; // 👈 tu bloc y modelos

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  // Controladores de texto
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final caregiverEmailController = TextEditingController();
  final caregiverPhoneController = TextEditingController();
  final doctorCodeController = TextEditingController();

  String? selectedRole; // paciente o doctor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserFullyRegistrated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Bienvenido ${state.user.name}")),
            );
          }
          if (state is UserNameExist) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("El nombre de usuario ya está registrado"),
              ),
            );
          }
          if (state is UserRegistrated) {
            if (state.user.role == 'patient') {
              final patient = Patient(
                userId: state.user.id!,
                caregiverNumber: caregiverPhoneController.text,
                caregiverEmail: caregiverEmailController.text,
              );
              context.read<AuthBloc>().add(RegisterPatientEvent(patient));
            }
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: const Text(
                  "Crear Cuenta",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "Rellena los campos y créate una cuenta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 57),

              // Campos principales
              CustomTextField(
                label: 'Nombre',
                hint: '',
                icon: Icons.person_outline,
                controller: nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Apellidos',
                hint: '',
                icon: Icons.badge_outlined,
                controller: lastNameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Teléfono',
                hint: '',
                icon: Icons.phone_outlined,
                controller: phoneController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Correo',
                hint: '',
                icon: Icons.email_outlined,
                controller: emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Usuario',
                hint: '',
                icon: Icons.person_2_outlined,
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
              const SizedBox(height: 30),

              // Radios para rol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: "patient",
                        // ignore: deprecated_member_use
                        groupValue: selectedRole,
                        activeColor: Colors.red.shade900,
                        // ignore: deprecated_member_use
                        onChanged: (val) => setState(() => selectedRole = val),
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
                        value: "doctor",
                        // ignore: deprecated_member_use
                        groupValue: selectedRole,
                        activeColor: Colors.blue.shade900,
                        // ignore: deprecated_member_use
                        onChanged: (val) => setState(() => selectedRole = val),
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

              // Campos condicionales
              if (selectedRole == "doctor") ...[
                CustomTextField(
                  label: 'Código',
                  hint: '',
                  icon: Icons.vpn_key_outlined,
                  controller: doctorCodeController,
                ),
              ] else if (selectedRole == "patient") ...[
                CustomTextField(
                  label: 'Teléfono del cuidador',
                  hint: '',
                  icon: Icons.phone_forwarded_outlined,
                  controller: caregiverPhoneController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Correo del cuidador',
                  hint: '',
                  icon: Icons.alternate_email_outlined,
                  controller: caregiverEmailController,
                ),
              ],

              const SizedBox(height: 30),

              // Botón de registro
              PrimaryButton(
                text: 'Registrarse',
                onPressed: () {
                  final user = User(
                    id: null,
                    name: nameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    phoneNumber: phoneController.text,
                    userName: usernameController.text,
                    passwordHash: passwordController.text,
                    role: selectedRole ?? '',
                  );
                  context.read<AuthBloc>().add(RegisterUserEvent(user));
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
