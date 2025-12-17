import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import 'package:app/features/auth/auth.dart';
import '../../../diary.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryBloc, DiaryState>(
      listener: (context, state) {
        if (state is DayChangedState) {
          // Aquí imprimes el día cambiado
          debugPrint("Día cambiado: ${state.selectedDay}");
        }
        if (state is CrisisAdded) {
          // Aquí imprimes la crisis añadida
          debugPrint("Crisis añadida: ${state.crisis.crisisDate.toString()}");
        }
        if (state is DiaryError) {
          // Aquí imprimes el error
          debugPrint("Error: ${state.message}");
        }

        if (state is TarjetasLoaded) {
          //  Aquí imprimes todas las crisis cargadas del día
          for (final crisis in state.crises) {
            debugPrint(
              "Crisis del día: tipo=${crisis.type}, horario=${crisis.timeRange}, cantidad=${crisis.quantity}, fecha=${crisis.crisisDate}",
            );
          }
        }
        if (state is TarjetasError) {
          debugPrint("Error cargando tarjetas: ${state.message}");
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
              // Calendario visual
              const SizedBox(height: 350, child: DiaryCalendar()),

              // Botones de acción
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
                        debugPrint("se obtuvo el result del dialog : $result");
                        if (result != null) {
                          // Obtenemos el día seleccionado del DiaryBloc
                          final daySelected = context
                              .read<DiaryBloc>()
                              .daySelected;
                          debugPrint("entro al el result");
                          // Obtenemos el usuario del AuthBloc
                          final authState = context.read<AuthBloc>().state;
                          int? userId;
                          if (authState is UserLoggedIn) {
                            userId = authState
                                .user
                                .id; // aquí usas la propiedad que tengas en tu modelo User          .id; // aquí usas la propiedad que tengas en tu modelo User
                            debugPrint("se obtuvo el userId: $userId");
                          }

                          // Creamos la entidad Crisis con los datos del formulario
                          final crisis = CrisisModel(
                            registeredDate: DateTime.now(),
                            crisisDate: daySelected,
                            timeRange: result.horario,
                            quantity: result.cantidad,
                            type: result.tipo,
                            userId: userId!, //  viene del AuthBloc
                          );

                          // Disparamos el evento al DiaryBloc
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

              // Contenido inferior placeholder
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
                icon: const Icon(
                  Icons.medication_outlined,
                  size: 32,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // Acción para medicación
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // Acción para perfil
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
