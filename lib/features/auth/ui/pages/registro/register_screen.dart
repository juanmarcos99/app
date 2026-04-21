import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/core.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final caregiverEmailController = TextEditingController();
  final caregiverPhoneController = TextEditingController();
  final doctorCodeController = TextEditingController();

  String selectedRole = "patient";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final heroImage = selectedRole == "doctor"
        ? "assets/images/doctor_register.png"
        : "assets/images/patient_register.png";

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserFullyRegistrated) {
            AppSnack.show(
              context,
              "Bienvenido ${state.user.userName}",
              color: AppColors.success,
            );
            Navigator.pop(context);
          }

          if (state is UserNameExist) {
            AppSnack.show(
              context,
              "El nombre de usuario ya está registrado",
              color: AppColors.error,
            );
          }

          if (state is UserRegistrated && state.user.role == 'patient') {
            final patient = Patient(
              userId: state.user.id!,
              caregiverNumber: caregiverPhoneController.text,
              caregiverEmail: caregiverEmailController.text,
            );
            context.read<AuthBloc>().add(RegisterPatientEvent(patient));
          }

          if (state is AuthFailure) {
            AppSnack.show(context, state.message, color: AppColors.error);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(heroImage, fit: BoxFit.cover),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(61, 0, 0, 0),
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
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Crear Cuenta",
                            style: theme.textTheme.displayLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Por favor, completa los datos para crear tu cuenta.",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _RoleTile(
                            title: "Paciente",
                            icon: Icons.person,
                            selected: selectedRole == "patient",
                            onTap: () =>
                                setState(() => selectedRole = "patient"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _RoleTile(
                            title: "Doctor",
                            icon: Icons.medical_services,
                            selected: selectedRole == "doctor",
                            onTap: () =>
                                setState(() => selectedRole = "doctor"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      label: 'Nombre',
                      icon: Icons.person_outline,
                      controller: nameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Apellidos',
                      icon: Icons.badge_outlined,
                      controller: lastNameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Teléfono',
                      icon: Icons.phone_outlined,
                      controller: phoneController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Correo',
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Usuario',
                      icon: Icons.person_2_outlined,
                      controller: usernameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      obscure: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 30),
                    if (selectedRole == "doctor") ...[
                      CustomTextField(
                        label: 'Código de Doctor',
                        icon: Icons.verified,
                        controller: doctorCodeController,
                      ),
                    ],
                    if (selectedRole == "patient") ...[
                      CustomTextField(
                        label: 'Teléfono del cuidador',
                        icon: Icons.contact_phone,
                        controller: caregiverPhoneController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Correo del cuidador',
                        icon: Icons.contact_mail,
                        controller: caregiverEmailController,
                      ),
                    ],
                    const SizedBox(height: 30),
                    PrimaryButton(
                      text: "Registrarse",
                      onPressed: () => _submit(context),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Ya tienes una cuenta?",
                          style: theme.textTheme.bodySmall,
                        ),
                        LetterNavButton(
                          letter: "Inicia Sesión",
                          onTap: () => Navigator.pop(context),
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, rellena todos los campos")),
      );
      return;
    }

    if (phoneController.text.isEmpty &&
        caregiverPhoneController.text.isEmpty &&
        selectedRole == "patient") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingresa al menos un teléfono"),
        ),
      );
      return;
    }

    if (selectedRole == "doctor" && doctorCodeController.text != "1234") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Código de doctor inválido")),
      );
      return;
    }

    final user = User(
      id: null,
      name: nameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      userName: usernameController.text,
      passwordHash: passwordController.text,
      role: selectedRole,
    );

    context.read<AuthBloc>().add(RegisterUserEvent(user));
  }
}

class _RoleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium!.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
