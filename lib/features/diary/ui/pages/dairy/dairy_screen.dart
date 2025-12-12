import 'package:app/features/diary/ui/pages/dairy/widgets/register_crisis_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app/features/diary/ui/diary_ui.dart';
import 'package:app/core/theme/style/colors.dart';

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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const RegisterCrisisDialog(),
                      );
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
