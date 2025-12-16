import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../diary.dart';
import 'package:app/features/auth/auth.dart'; // para leer AuthBloc

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DiaryBloc>(), // inyecta el bloc
      child: BlocListener<DiaryBloc, DiaryState>(
        listener: (context, state) {
          if (state is DaySelected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Día seleccionado: ${state.selectedDay.toLocal()}")),
            );
          } else if (state is CrisisAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Crisis registrada correctamente")),
            );
          } else if (state is DiaryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text("Diario", style: TextStyle(color: AppColors.white)),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 350, child: DiaryCalendar()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomActionButton(
                        text: "Añadir crisis",
                        icon: Icons.add,
                        backgroundColor: AppColors.primary,
                        onPressed: () async {
                          final result = await showDialog<CrisisFormResult>(
                            context: context,
                            useRootNavigator: false,
                            builder: (_) => const RegisterCrisisDialog(),
                          );

                          if (result != null) {
                            final diaryBloc = context.read<DiaryBloc>();
                            final authState = context.read<AuthBloc>().state;

                            if (authState is UserLoggedIn) {
                              final crisis = Crisis(
                                registeredDate: DateTime.now(),
                                crisisDate: diaryBloc.selectedDay ?? DateTime.now(),
                                timeRange: result.horario,
                                quantity: result.cantidad,
                                type: result.tipo,
                                userId: authState.user.id!,
                              );

                              diaryBloc.add(AddCrisisEvent(crisis));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Debes iniciar sesión.")),
                              );
                            }
                          }
                        },
                      ),
                      CustomActionButton(
                        text: "Añadir Efecto",
                        icon: Icons.add,
                        backgroundColor: AppColors.secundary,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            useRootNavigator: false,
                            builder: (_) => const RegistroEfectDialog(),
                          );
                          // aquí puedes hacer lo mismo: recoger datos y llamar al bloc
                        },
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(child: Text("Aquí va el contenido inferior")),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.medication_outlined, size: 32, color: AppColors.primary),
                  onPressed: () {
                    // Acción para medicación
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person, size: 32, color: AppColors.primary),
                  onPressed: () {
                    // Acción para perfil
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
