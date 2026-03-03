import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';
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

    // Obtener userId desde AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      userId = authState.user.id!;
      context.read<AppointmentBloc>().add(LoadAppointmentsEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cita añadida correctamente"),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<AppointmentBloc>().add(LoadAppointmentsEvent(userId!));
        }

        if (state is AppointmentDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cita eliminada"),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<AppointmentBloc>().add(LoadAppointmentsEvent(userId!));
        }

        if (state is AppointmentError) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: SelectableText(
                state.message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título
              const Text(
                "Selecciona el día de tu\nturno médico",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "Elige una fecha disponible para tu consulta",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Botón agendar turno
              Center(
                child: PrimaryButton(
                  text: "Agendar",
                  onPressed: () async {
                    final result = await showDialog<Appointment>(
                      context: context,
                      useRootNavigator: false,
                      builder: (_) => const AppointmentDialog(),
                    );

                    if (result != null && userId != null) {
                      final appointmentWithUser = result.copyWith(userId: userId);
                      context.read<AppointmentBloc>().add(
                        AddAppointmentEvent(appointmentWithUser),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Lista de citas
              Expanded(
                child: BlocBuilder<AppointmentBloc, AppointmentState>(
                  builder: (context, state) {
                    if (state is AppointmentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is AppointmentLoaded) {
                      if (state.appointments.isEmpty) {
                        return const Center(
                          child: Text(
                            "No hay citas registradas",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = state.appointments[index];
                          return AppointmentCard(appointment: appointment);
                        },
                      );
                    }

                    if (state is AppointmentError) {
                      return Center(
                        child: SelectableText(
                          state.message,
                          style: const TextStyle(color: AppColors.error),
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
    );
  }
}
