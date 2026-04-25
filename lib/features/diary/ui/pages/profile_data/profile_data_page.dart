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
  User? userBeforeUpdate;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      userBeforeUpdate = authState.user;
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
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            nameController.text = state.user.name;
            userNameController.text = state.user.userName;
            lastNameController.text = state.user.lastName;
            phoneController.text = state.user.phoneNumber;
            emailController.text = state.user.email;

            if (state.patient != null) {
              caregiverEmailController.text = state.patient!.caregiverEmail;
              caregiverPhoneController.text = state.patient!.caregiverNumber;
            }
          } else if (state is ProfileUpdated || state is ProfileDeleted) {
            AppSnack.show(
              context,
              state is ProfileUpdated
                  ? "Perfil actualizado correctamente"
                  : "Cuenta eliminada",
            );
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is ProfileError) {
            AppSnack.show(context, state.message, color: AppColors.error);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- SECCIÓN HERO (Basada en tu diseño de cambiar contraseña) ---
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/profile_info.png',
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
                              theme.scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      left: 32,
                      right: 32,
                      bottom: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gestión del perfil",
                            style: theme.textTheme.displayLarge!.copyWith(
                              color: Colors.white,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Consulta y administra tu información personal",
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

              // --- CONTENIDO DEL FORMULARIO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Nombre",
                      icon: Icons.person_outline,
                      controller: nameController,
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
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      label: "Correo",
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      label: "Usuario",
                      icon: Icons.person_outline,
                      controller: userNameController,
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
                    PrimaryButton(text: "Guardar", onPressed: _onSavePressed),
                    const SizedBox(height: 30),
                    CustomOptionButton(
                      text: "Eliminar Cuenta",
                      icon: Icons.delete_outline_outlined,
                      color: AppColors.error,
                      onPressed: _onDeletePressed,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSavePressed() {
    if (nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      User userUpdate = userBeforeUpdate!.copyWith(
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        userName: userNameController.text,
      );

      Patient? patientUpdate;
      if (userUpdate.role == "patient") {
        patientUpdate = Patient(
          userId: userUpdate.id!,
          caregiverEmail: caregiverEmailController.text,
          caregiverNumber: caregiverPhoneController.text,
        );
      }

      if (userBeforeUpdate != null) {
        context.read<ProfileBloc>().add(
          UpdateProfileData(userBeforeUpdate!, userUpdate, patientUpdate),
        );
      }
    } else {
      AppSnack.show(
        context,
        "Todos los campos deben estar llenos",
        color: AppColors.error,
      );
    }
  }

  Future<void> _onDeletePressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmationDialog(
        title: "Eliminar Perfil",
        message:
            "¿Seguro que deseas eliminar el perfil de \"${userBeforeUpdate!.name}\"?\nEsta acción no se puede deshacer.",
        confirmText: "Eliminar",
        confirmColor: Colors.red,
      ),
    );

    if (userBeforeUpdate != null && confirmed == true) {
      context.read<ProfileBloc>().add(DeleteProfile(userBeforeUpdate!));
    }
  }
}
