import 'package:flutter/material.dart';
import 'package:app/features/diary/ui/diary_ui.dart';
import 'package:app/features/diary/domain/diary_domain.dart';
import 'package:app/core/theme/style/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Diario", style: TextStyle(color: AppColors.white)),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // vuelve a la pantalla anterior
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendario con altura fija
            const SizedBox(height: 350, child: DiaryCalendar()),
            // Botones pegados justo debajo del calendario
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
                      // 1. Abrir el diálogo y esperar el detalle
                      // 1. Abrir el diálogo y esperar el detalle
                      final detalle = await showDialog<CrisisDetalle>(
                        context: context,
                        builder: (context) => const RegisterCrisisDialog(),
                      );
                      // 2. Si el usuario guardó algo en el diálogo
                      if (detalle != null) {
                        final bloc = context.read<DiaryBloc>();
                        final crisis = Crisis(
                          id: null,
                          fechaRegistro: DateTime.now(), // cuándo se registra
                          fechaCrisis: bloc
                              .selectedDay, // día que el usuario eligió en el calendario
                          usuarioId: 1, // usuario actual
                          detalles: [detalle], // lista con el detalle
                        );
                        // 4. Disparar el evento al Bloc
                        bloc.add(AddCrisisEvent(crisis));
                      }
                    },
                  ),
                  CustomActionButton(
                    text: "Añadir Efecto",
                    icon: Icons.add,
                    backgroundColor: AppColors.secundary,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const RegistroEfectDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),

            //  Espacio para el resto del contenido
            const Expanded(
              child: Center(child: Text("Aquí va el contenido inferior")),
            ),
          ],
        ),
      ),

      //  Pie de pantalla con iconos de píldoras y usuario
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de píldoras
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
            // Botón de usuario
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
    );
  }
}
