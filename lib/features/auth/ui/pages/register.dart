import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      appBar: AppBar(title: const Text("Registro")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserFullyRegistrated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.user.name)));
          }
          if (state is UserNameExist) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("el nombre se user ya esta registrado")));
          }
          
          if (state is UserRegistrated) {
            //aquí validas que el rol es paciente
            if (state.user.role == 'patient') {
              final patient = Patient(
                userId: state.user.id!, // ya viene con id
                caregiverNumber: caregiverPhoneController.text,
                caregiverEmail: caregiverEmailController.text,
              );
              context.read<AuthBloc>().add(RegisterPatientEvent(patient));
            }
          }
          if (state is AuthLoading) {
            
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Apellidos"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Correo"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Teléfono"),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de usuario",
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),

              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: "patient", child: Text("Paciente")),
                  DropdownMenuItem(value: "doctor", child: Text("Doctor")),
                ],
                onChanged: (value) => setState(() => selectedRole = value),
                decoration: const InputDecoration(labelText: "Rol"),
              ),

              const SizedBox(height: 20),
              if (selectedRole == "patient") ...[
                TextField(
                  controller: caregiverEmailController,
                  decoration: const InputDecoration(
                    labelText: "Correo del cuidador",
                  ),
                ),
                TextField(
                  controller: caregiverPhoneController,
                  decoration: const InputDecoration(
                    labelText: "Teléfono del cuidador",
                  ),
                ),
              ],
              if (selectedRole == "doctor") ...[
                TextField(
                  controller: doctorCodeController,
                  decoration: const InputDecoration(
                    labelText: "Código de doctor",
                  ),
                ),
              ],

              const SizedBox(height: 30),
              ElevatedButton(
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
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
