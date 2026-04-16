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
    // Extraemos el tema actual
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return BlocListener<MedicationBloc, MedicationState>(
      listener: (context, state) {
        if (state is MedicationAdded) {
          AppSnack.show(
            context,
            "Medicamento añadido correctamente",
            color: AppColors.success,
          );

          final authState = context.read<AuthBloc>().state;
          if (authState is UserLoggedIn) {
            userId = authState.user.id!;
            context.read<MedicationBloc>().add(LoadMedicationsEvent(userId!));
          }
        }

        if (state is MedicationUpdated) {
          AppSnack.show(
            context,
            "Medicamento actualizado",
            color: AppColors.primary,
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
          AppSnack.show(
            context,
            "Medicamento eliminado",
            color: AppColors.error,
          );
        }

        if (state is MedicationError) {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                backgroundColor: cs.surface,
                title: Text("Error", style: TextStyle(color: cs.error)),
                content: SelectableText(
                  state.message,
                  style: textStyle.bodyLarge,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cerrar", style: TextStyle(color: cs.primary)),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface, // Dinámico (Fondo oscuro o claro)
        floatingActionButton: FloatingActionButton(
          backgroundColor: cs.primary,
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
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ), // Color de contraste dinámico
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<MedicationBloc, MedicationState>(
                  builder: (context, state) {
                    if (state is MedicationLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: cs.primary),
                      );
                    }

                    if (state is MedicationLoaded) {
                      if (state.medications.isEmpty) {
                        return Center(
                          child: Text(
                            "No hay medicamentos registrados",
                            style: textStyle.bodyLarge?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
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
                          state.message,
                          style: textStyle.bodyMedium?.copyWith(
                            color: cs.error,
                          ),
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
