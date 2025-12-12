import 'package:app/core/theme/style/colors.dart';
import 'package:flutter/material.dart';

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
  final List<Map<String, TextEditingController>> otrosCampos = [];

  @override
  void dispose() {
    cantidadController.dispose();
    for (var campo in otrosCampos) {
      campo['descripcion']?.dispose();
      campo['cantidad']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Registro de Crisis"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // más ancho
        height: MediaQuery.of(context).size.height * 0.6, // más alto
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Horario
              DropdownButtonFormField<String>(
                value: horario,
                items: horarios.map((h) {
                  return DropdownMenuItem(value: h, child: Text(h));
                }).toList(),
                onChanged: (value) => setState(() => horario = value),
                decoration: const InputDecoration(
                  labelText: "Horario",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Tipo de crisis (desplegable)
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                items: tiposCrisis.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoSeleccionado = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Tipo de crisis",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de cantidad (solo aparece si se eligió un tipo)
              if (tipoSeleccionado != null)
                TextFormField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Cantidad de crisis ($tipoSeleccionado)",
                    border: const OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 20),

              // Campos dinámicos (otros tipos añadidos manualmente)
              for (var i = 0; i < otrosCampos.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: otrosCampos[i]['descripcion'],
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: otrosCampos[i]['cantidad'],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Cantidad",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            otrosCampos.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    otrosCampos.add({
                      "descripcion": TextEditingController(),
                      "cantidad": TextEditingController(),
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("Añadir otro tipo"),
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
            final horarioSel = horario ?? "";
            final tipoSel = tipoSeleccionado ?? "";
            final cantidad = cantidadController.text.trim();

            print("Horario: $horarioSel, Tipo: $tipoSel, Cantidad: $cantidad");

            Navigator.pop(context);
          },
          icon: const Icon(Icons.save, color: AppColors.white),
          label: const Text(
            "Guardar",
            style: TextStyle(color: AppColors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
