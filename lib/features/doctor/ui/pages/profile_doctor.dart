  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/diary/ui/pages/profile_data/widgets/custom_option_button.dart';
import 'package:app/features/doctor/ui/bloc/profile_doctor_bloc/profile_doctor_bloc.dart';
import 'package:app/features/doctor/ui/bloc/profile_doctor_bloc/profile_doctor_event_state.dart';
import 'package:app/app_routes.dart';

class ProfileDoctor extends StatefulWidget {
  const ProfileDoctor({super.key});

  @override
  State<ProfileDoctor> createState() => _ProfileDoctorState();
}

class _ProfileDoctorState extends State<ProfileDoctor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  User? _userBeforeUpdate;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      _userBeforeUpdate = authState.user;
      context.read<ProfileDoctorBloc>().add(
            LoadProfileDoctorData(authState.user),
          );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocListener<ProfileDoctorBloc, ProfileDoctorState>(
        listener: (context, state) {
          if (state is ProfileDoctorLoaded) {
            nameController.text = state.user.name;
            lastNameController.text = state.user.lastName;
            phoneController.text = state.user.phoneNumber;
            emailController.text = state.user.email;
            userNameController.text = state.user.userName;
          } else if (state is ProfileDoctorUpdated) {
            AppSnack.show(context, 'Perfil actualizado correctamente');
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
          } else if (state is ProfileDoctorDeleted) {
            AppSnack.show(context, 'Cuenta eliminada exitosamente');
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
          } else if (state is ProfileDoctorError) {
            AppSnack.show(context, state.message, color: AppColors.error);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero section
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
                    // Gradient overlay
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
                    // Back button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    // Title
                    Positioned(
                      left: 32,
                      right: 32,
                      bottom: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestión del perfil',
                            style: theme.textTheme.displayLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Consulta y administra tu información personal',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Nombre',
                      icon: Icons.person_outline,
                      controller: nameController,
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      label: 'Apellidos',
                      icon: Icons.badge_outlined,
                      controller: lastNameController,
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      label: 'Teléfono',
                      icon: Icons.phone_outlined,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      label: 'Correo',
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      label: 'Usuario',
                      icon: Icons.person_outline,
                      controller: userNameController,
                    ),
                    const SizedBox(height: 35),
                    BlocBuilder<ProfileDoctorBloc, ProfileDoctorState>(
                      builder: (context, state) {
                        return CustomOptionButton(
                          text: 'Eliminar cuenta',
                          color: AppColors.error,
                          onPressed: () => _confirmDelete(context),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<ProfileDoctorBloc, ProfileDoctorState>(
                      builder: (context, state) {
                        if (state is ProfileDoctorLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PrimaryButton(
                          text: 'Guardar',
                          onPressed: _onSavePressed,
                        );
                      },
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

  void _confirmDelete(BuildContext context) {
    if (_userBeforeUpdate == null) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar perfil'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar tu perfil permanentemente? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              context.read<ProfileDoctorBloc>().add(
                    DeleteProfileDoctorData(_userBeforeUpdate!),
                  );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _onSavePressed() {
    if (nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      final updated = _userBeforeUpdate!.copyWith(
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        userName: userNameController.text,
      );

      context.read<ProfileDoctorBloc>().add(
            UpdateProfileDoctorData(_userBeforeUpdate!, updated),
          );
    } else {
      AppSnack.show(
        context,
        'Todos los campos deben estar llenos',
        color: AppColors.error,
      );
    }
  }
}
