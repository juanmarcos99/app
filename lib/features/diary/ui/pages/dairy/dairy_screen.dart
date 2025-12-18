import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import 'package:app/features/auth/auth.dart';
import '../../../diary.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is UserLoggedIn) {
        context.read<DiaryBloc>().add(
          LoadTarjetasEvent(
            userId: authState.user.id!,
            date: context.read<DiaryBloc>().daySelected,
          ),
        );

        // También puedes disparar el calendario si quieres marcar los días
        context.read<DiaryBloc>().add(LoadCalendarEvent(authState.user.id!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryBloc, DiaryState>(
      listener: (context, state) {
        if (state is DayChangedState) {
          debugPrint("Día cambiado: ${state.selectedDay}");
        }
        if (state is CrisisAdded) {
          final authState = context.read<AuthBloc>().state;
          if (authState is UserLoggedIn) {
            context.read<DiaryBloc>().add(
              LoadTarjetasEvent(
                userId: authState.user.id!,
                date: context.read<DiaryBloc>().daySelected,
              ),
            );
            debugPrint("se obtuvo el userId:");
          }
        }
        if (state is TarjetasLoaded) {
          for (final crisis in state.crises) {
            debugPrint(
              "Crisis del día: tipo=${crisis.type}, horario=${crisis.timeRange}, cantidad=${crisis.quantity}, fecha=${crisis.crisisDate}",
            );
          }
        }
        if (state is TarjetasError) {
          debugPrint("Error cargando tarjetas: ${state.message}");
        }
        if (state is DiaryError) {
          debugPrint("Error general: ${state.message}");
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                          final daySelected = context
                              .read<DiaryBloc>()
                              .daySelected;
                          final authState = context.read<AuthBloc>().state;
                          int? userId;
                          if (authState is UserLoggedIn) {
                            userId = authState.user.id;
                          }

                          final crisis = CrisisModel(
                            registeredDate: DateTime.now(),
                            crisisDate: daySelected,
                            timeRange: result.horario,
                            quantity: result.cantidad,
                            type: result.tipo,
                            userId: userId!,
                          );

                          context.read<DiaryBloc>().add(AddCrisisEvent(crisis));
                        }
                      },
                    ),
                    CustomActionButton(
                      text: "Añadir Efecto",
                      icon: Icons.add,
                      backgroundColor: AppColors.secundary,
                      onPressed: () async {},
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<DiaryBloc, DiaryState>(
                  buildWhen: (previous, current) =>
                      current is TarjetasLoaded || current is TarjetasError,
                  builder: (context, state) {
                    if (state is TarjetasLoaded) {
                      if (state.crises.isEmpty) {
                        return const Center(
                          child: Text("No hay crisis registradas en este día"),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.crises.length,
                        itemBuilder: (context, index) {
                          final crisis = state.crises[index];
                          return CrisisCard(
                            tipo: crisis.type,
                            horario: crisis.timeRange,
                            cantidad: crisis.quantity,
                            fecha: crisis.crisisDate,
                          );
                        },
                      );
                    }
                    if (state is TarjetasError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const Center(
                      child: Text("Selecciona un día para ver las crisis"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
       bottomNavigationBar: CustomBottomNavBar(
  currentIndex: 1, // 🔥 el calendario estará seleccionado al abrir
  onTap: (index) {
    // Aquí manejas la acción según el ícono tocado
    switch (index) {
      case 0:
        debugPrint("Home seleccionado");
        break;
      case 1:
        debugPrint("Calendario seleccionado");
        break;
      case 2:
        debugPrint("Agregar seleccionado");
        break;
      case 3:
        debugPrint("Notas seleccionadas");
        break;
      case 4:
        debugPrint("Ajustes seleccionados");
        break;
    }
  },
),
      ),
    );
  }
}
