import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  int? userId;

  @override
  void initState() {
    super.initState();

    // Obtener userId desde AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      userId = authState.user.id!;
      context.read<MedicationBloc>().add(LoadMedicationsEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationBloc, MedicationState>(
      listener: (context, state) {
        if (state is MedicationAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Medicamento añadido correctamente"),
              backgroundColor: AppColors.success,
            ),
          );

          final authState = context.read<AuthBloc>().state;
          if (authState is UserLoggedIn) {
            userId = authState.user.id!;
            context.read<MedicationBloc>().add(LoadMedicationsEvent(userId!));
          }
        }

        if (state is MedicationUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Medicamento actualizado"),
              backgroundColor: AppColors.primary,
            ),
          );
          final authState = context.read<AuthBloc>().state;
          if (authState is UserLoggedIn) {
            userId = authState.user.id!;
            context.read<MedicationBloc>().add(LoadMedicationsEvent(userId!));
          }
        }

        if (state is MedicationDeleted) {
          final authState = context.read<AuthBloc>().state;
          if (authState is UserLoggedIn) {
            userId = authState.user.id!;
            context.read<MedicationBloc>().add(LoadMedicationsEvent(userId!));
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Medicamento eliminado"),
              backgroundColor: AppColors.error,
            ),
          );
        }

        if (state is MedicationError) {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                content: SelectableText(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.white,

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          elevation: 4,
          onPressed: () async {
            final result = await showDialog<(Medication, bool)>(
              context: context,
              useRootNavigator: false,
              builder: (_) => const RegisterMedicationDialog(),
            );

            if (result != null && userId != null) {
              final (medication, shouldSchedule) = result;

              final medWithUser = medication.copyWith(userId: userId!);

              context.read<MedicationBloc>().add(
                AddMedicationEvent(medWithUser, shouldSchedule),
              );
            }
          },
          child: const Icon(Icons.add, color: AppColors.white),
        ),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<MedicationBloc, MedicationState>(
                  builder: (context, state) {
                    if (state is MedicationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MedicationLoaded) {
                      if (state.medications.isEmpty) {
                        return const Center(
                          child: Text(
                            "No hay medicamentos registrados",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: state.medications.length,
                        itemBuilder: (context, index) {
                          final med = state.medications[index];
                          return MedicationCard(medication: med);
                        },
                      );
                    }

                    if (state is MedicationError) {
                      return Center(
                        child: SelectableText(
                          // Copiable también aquí
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
