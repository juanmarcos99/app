import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class CrisisFormResult {
  final DateTime fecha;
  final String horario;
  final String tipo;
  final int cantidad;

  const CrisisFormResult({
    required this.fecha,
    required this.horario,
    required this.tipo,
    required this.cantidad,
  });
}

class RegisterCrisisDialog extends StatefulWidget {
  const RegisterCrisisDialog({super.key});

  @override
  State<RegisterCrisisDialog> createState() => _RegisterCrisisDialogState();
}

class _RegisterCrisisDialogState extends State<RegisterCrisisDialog> {
  final DateTime fecha = DateTime.now();

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
    'Añadir otro tipo',
  ];

  final cantidadController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  void dispose() {
    cantidadController.dispose();
    descripcionController.dispose();
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
        height: MediaQuery.of(context).size.height * 0.55,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horario
              const Text("Horario del episodio", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: horario,
                items: horarios.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                onChanged: (value) => setState(() => horario = value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              // Tipo de crisis
              const Text("Tipo de crisis", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                items: tiposCrisis.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => setState(() => tipoSeleccionado = value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              // Campos según selección
              if (tipoSeleccionado != null && tipoSeleccionado != 'Añadir otro tipo')
                TextFormField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Cantidad de crisis ($tipoSeleccionado)",
                    border: const OutlineInputBorder(),
                  ),
                ),

              if (tipoSeleccionado == 'Añadir otro tipo') ...[
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción del tipo",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Cantidad",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
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
          // Siempre activo, sin validación previa
          onPressed: () {
            final tipoFinal = tipoSeleccionado == 'Añadir otro tipo'
                ? descripcionController.text.trim()
                : tipoSeleccionado ?? '';

            final result = CrisisFormResult(
              fecha: fecha,
              horario: horario ?? '',
              tipo: tipoFinal,
              cantidad: int.tryParse(cantidadController.text.trim()) ?? 0,
            );
            Navigator.pop(context, result);
          },
          icon: const Icon(Icons.save, color: AppColors.white),
          label: const Text("Guardar", style: TextStyle(color: AppColors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
      ],
    );
  }
}
