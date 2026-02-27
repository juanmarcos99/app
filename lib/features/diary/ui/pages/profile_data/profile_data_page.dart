import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';

class ProfileDataPage extends StatefulWidget {
  const ProfileDataPage({super.key});

  @override
  State<ProfileDataPage> createState() => _ProfileDataPageState();
}

class _ProfileDataPageState extends State<ProfileDataPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController caregiverEmailController = TextEditingController();
  TextEditingController caregiverPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      context.read<ProfileBloc>().add(LoadProfileData(authState.user));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    caregiverEmailController.dispose();
    caregiverPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              // Datos del usuario
              nameController.text = state.user.name;
              userNameController.text = state.user.userName;
              lastNameController.text = state.user.lastName;
              phoneController.text = state.user.phoneNumber;
              emailController.text = state.user.email;

              // Datos del paciente (si existe)
              if (state.patient != null) {
                caregiverEmailController.text = state.patient!.caregiverEmail;
                caregiverPhoneController.text = state.patient!.caregiverNumber;
              } else {
                caregiverEmailController.clear();
                caregiverPhoneController.clear();
              }
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    "Gestión del perfil",
                    style: AppTypography.headline2Light,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 19),
                Text(
                  "Consulta y administra tu información personal",
                  style: AppTypography.captionLight,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: "Nombre",
                  icon: Icons.person_outline,
                  controller: nameController,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: "Usuario",
                  icon: Icons.person_outline,
                  controller: userNameController,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: "Apellidos",
                  icon: Icons.badge_outlined,
                  controller: lastNameController,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: "Teléfono",
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: "Correo",
                  icon: Icons.email_outlined,
                  controller: emailController,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: 'Correo del cuidador',
                  icon: Icons.alternate_email_outlined,
                  controller: caregiverEmailController,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: 'Teléfono del cuidador',
                  icon: Icons.phone_forwarded_outlined,
                  controller: caregiverPhoneController,
                ),
                const SizedBox(height: 43),
                Center(
                  child: PrimaryButton(
                    text: "Guardar",
                    onPressed: () {
                      // Aquí luego dispararemos UpdateProfileData
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: CustomOptionButton(
                    text: "Eliminar Cuenta",
                    icon: Icons.delete_outline_outlined,
                    color: AppColors.error,
                    onPressed: () {
                      // Aquí luego dispararemos DeleteProfile
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
