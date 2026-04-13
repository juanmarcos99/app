import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';

class MedicalAppointmentPage extends StatefulWidget {
  const MedicalAppointmentPage({super.key});

  @override
  State<MedicalAppointmentPage> createState() => _MedicalAppointmentPageState();
}

class _MedicalAppointmentPageState extends State<MedicalAppointmentPage> {
  int? userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      userId = authState.user.id!;
      context.read<AppointmentBloc>().add(LoadAppointmentsEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentAdded) {
          AppSnack.show(context, "Cita añadida correctamente");
          context.read<AppointmentBloc>().add(LoadAppointmentsEvent(userId!));
        }

        if (state is AppointmentDeleted) {
          AppSnack.show(context, "Cita eliminada", color: AppColors.error);
          context.read<AppointmentBloc>().add(LoadAppointmentsEvent(userId!));
        }

        if (state is AppointmentError) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: theme.dialogBackgroundColor,
              content: SelectableText(
                state.message,
                style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            // --- SECCIÓN HERO CON IMAGEN ---
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/appointment.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Degradado para integrar con el fondo
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
                  // Botón de atrás
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // Títulos sobre la imagen
                  Positioned(
                    left: 32,
                    right: 32,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Turno médico",
                          style: theme.textTheme.displayLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Selecciona el día de tu consulta",
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

            // --- CONTENIDO INFERIOR ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    PrimaryButton(
                      text: "Agendar",
                      onPressed: () async {
                        final result = await showDialog<Appointment>(
                          context: context,
                          useRootNavigator: false,
                          builder: (_) => const AppointmentDialog(),
                        );

                        if (result != null && userId != null) {
                          final appointmentWithUser = result.copyWith(
                            userId: userId,
                          );
                          context.read<AppointmentBloc>().add(
                            AddAppointmentEvent(appointmentWithUser),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    // Lista de citas
                    Expanded(
                      child: BlocBuilder<AppointmentBloc, AppointmentState>(
                        builder: (context, state) {
                          if (state is AppointmentLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is AppointmentLoaded) {
                            if (state.appointments.isEmpty) {
                              return Center(
                                child: Text(
                                  "No hay citas registradas",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: state.appointments.length,
                              itemBuilder: (context, index) {
                                return AppointmentCard(
                                  appointment: state.appointments[index],
                                );
                              },
                            );
                          }

                          if (state is AppointmentError) {
                            return Center(
                              child: SelectableText(
                                state.message,
                                style: TextStyle(color: colorScheme.error),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
