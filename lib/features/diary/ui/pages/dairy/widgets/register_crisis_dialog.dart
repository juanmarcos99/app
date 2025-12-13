import 'package:app/core/theme/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/features/diary/dairy.dart'; // importa tu entidad

class RegisterCrisisDialog extends StatefulWidget {
  const RegisterCrisisDialog({super.key});

  @override
  State<RegisterCrisisDialog> createState() => _RegisterCrisisDialogState();
}

class _RegisterCrisisDialogState extends State<RegisterCrisisDialog> {
  String? horario;
  String? tipoSeleccionado;

  final List<String> horarios = [
    '6:00 am - 10:00 am',
    '10:00 am - 2:00 pm',
    '2:00 pm - 6:00 pm',
    '6:00 pm - 10:00 pm',
    '10:00 pm - 6:00 am',
  ];

  final List<String> tiposCrisis = [
    'Focales conscientes',
    'Focales inconscientes',
    'Tónico-clónico bilateral',
  ];

  final cantidadController = TextEditingController();

  @override
  void dispose() {
    cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Registro de Crisis"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: horario,
                items: horarios.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                onChanged: (value) => setState(() => horario = value),
                decoration: const InputDecoration(
                  labelText: "Horario",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                items: tiposCrisis.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => setState(() => tipoSeleccionado = value),
                decoration: const InputDecoration(
                  labelText: "Tipo de crisis",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              if (tipoSeleccionado != null)
                TextFormField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Cantidad de crisis ($tipoSeleccionado)",
                    border: const OutlineInputBorder(),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Validar campos
            if (horario == null || tipoSeleccionado == null || cantidadController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Completa todos los campos")),
              );
              return;
            }

            // Construir CrisisDetalle
            final detalle = CrisisDetalle(
              id: null,
              crisisId: 0, // se asignará al guardar la Crisis
              horario: horario!,
              tipo: tipoSeleccionado!,
              cantidad: int.tryParse(cantidadController.text.trim()) ?? 0,
            );

            // Devolverlo al que abrió el diálogo
            Navigator.pop(context, detalle);
          },
          icon: const Icon(Icons.save, color: AppColors.white),
          label: const Text("Guardar", style: TextStyle(color: AppColors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
      ],
    );
  }
}
