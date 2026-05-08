import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RouteAware {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<AuthBloc>().add(LoadRememberedUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthFailure ||
            current is UserLoggedIn ||
            current is RememberUsersLoaded ||
            current is PasswordLoaded ||
            current is SyncError ||
            current is RemoteError,
        listener: (context, state) {
          if (state is AuthFailure) {
            AppSnack.show(context, state.message, color: AppColors.error);
          }
          if (state is RemoteError) {
            AppSnack.show(context, state.message, color: AppColors.error);
          }
          if (state is SyncError) {
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
            if (state.user.role == 'doctor') {
              Navigator.pushNamed(context, AppRoutes.doctorHomeScreen);
            } else {
              Navigator.pushNamed(context, AppRoutes.mainNavigationPage);
            }
          }
          if (state is RememberUsersLoaded) {
            setState(() => rememberedUsers = state.users);
          }
          if (state is PasswordLoaded) {
            passwordController.text = state.password;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // ---------------- HERO SIN SAFEAREA ----------------
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/login_hero1.png',
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
                                Color.fromARGB(0, 0, 0, 0),
                                theme.colorScheme.surface,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- CONTENIDO CON SAFEAREA ----------------
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        Text(
                          "Iniciar Sesión",
                          style: theme.textTheme.displayLarge,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Bienvenido de nuevo. Por favor, ingrese sus credenciales para continuar.",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

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
                            context
                                .read<AuthBloc>()
                                .add(LoadPasswordEvent(username));
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
                                Text(
                                  "Recordarme",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                           
                          ],
                        ),

                        const SizedBox(height: 30),

                        PrimaryButton(
                          text: 'Entrar',
                          onPressed: () {
                            if (autocompleteController != null) {
                              usernameController.text =
                                  autocompleteController!.text.trim();
                            }
                            final username = usernameController.text.trim();
                            final password = passwordController.text.trim();
                            context.read<AuthBloc>().add(
                                  LoginUserEvent(
                                      username, password, rememberMe),
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
                          color: theme.colorScheme.primary,
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Aún no tienes cuenta?",
                              style: theme.textTheme.bodySmall,
                            ),
                            LetterNavButton(
                              letter: "Regístrate",
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.register);
                              },
                              fontSize: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
