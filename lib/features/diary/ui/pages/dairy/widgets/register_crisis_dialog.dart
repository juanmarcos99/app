import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

/// Modelo de datos que devuelve el diálogo
class CrisisFormResult {
  final String horario;
  final String tipo;
  final int cantidad;

  const CrisisFormResult({
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

  bool get isValid =>
      horario != null &&
      tipoSeleccionado != null &&
      cantidadController.text.isNotEmpty &&
      int.tryParse(cantidadController.text) != null;

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
                items: horarios
                    .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                    .toList(),
                onChanged: (value) => setState(() => horario = value),
                decoration: const InputDecoration(
                  labelText: "Horario",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                items: tiposCrisis
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
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
          onPressed: isValid
              ? () {
                  final result = CrisisFormResult(
                    horario: horario!,
                    tipo: tipoSeleccionado!,
                    cantidad: int.parse(cantidadController.text),
                  );
                  Navigator.pop(context, result); // 🔥 devuelve los datos
                }
              : null,
          icon: const Icon(Icons.save, color: AppColors.white),
          label: const Text(
            "Guardar",
            style: TextStyle(color: AppColors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
      ],
    );
  }
}
