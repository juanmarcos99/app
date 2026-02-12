import 'package:app/features/diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class RegisterCrisisDialog extends StatefulWidget {
  final Crisis? initialCrisis;

  const RegisterCrisisDialog({super.key, this.initialCrisis});

  @override
  State<RegisterCrisisDialog> createState() => _RegisterCrisisDialogState();
}

class _RegisterCrisisDialogState extends State<RegisterCrisisDialog> {
  late DateTime fecha;
  String? horario;
  String? tipoSeleccionado;

  final _formKey = GlobalKey<FormState>();

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

  bool get isEditing => widget.initialCrisis != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final crisis = widget.initialCrisis!;
      fecha = crisis.crisisDate ?? DateTime.now();
      horario = horarios.contains(crisis.timeRange) ? crisis.timeRange : null;
      tipoSeleccionado = tiposCrisis.contains(crisis.type)
          ? crisis.type
          : 'Añadir otro tipo';

      if (tipoSeleccionado == 'Añadir otro tipo') {
        descripcionController.text = crisis.type ?? '';
      }

      cantidadController.text = crisis.quantity?.toString() ?? '';
    } else {
      fecha = DateTime.now();
      horario = null;
      tipoSeleccionado = null;
    }
  }

  @override
  void dispose() {
    cantidadController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void _onSave() {
    // valida todos los campos del formulario
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final tipoFinal = tipoSeleccionado == 'Añadir otro tipo'
        ? descripcionController.text.trim()
        : tipoSeleccionado ?? '';

    final crisis = Crisis(
      id: widget.initialCrisis?.id,
      registeredDate: widget.initialCrisis?.registeredDate,
      crisisDate: fecha,
      timeRange: horario ?? '',
      quantity: int.tryParse(cantidadController.text.trim()) ?? 0,
      type: tipoFinal,
      userId: widget.initialCrisis?.userId,
    );

    Navigator.pop(context, crisis);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(isEditing ? "Editar Crisis" : "Registro de Crisis"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.55,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // formulario para validaciones
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Horario del episodio",
                    style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  initialValue: horario,
                  items: horarios
                      .map((h) =>
                          DropdownMenuItem(value: h, child: Text(h)))
                      .toList(),
                  onChanged: (value) => setState(() => horario = value),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un horario';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text("Tipo de crisis", style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  initialValue: tipoSeleccionado,
                  items: tiposCrisis
                      .map((t) =>
                          DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => tipoSeleccionado = value),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un tipo de crisis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (tipoSeleccionado != null &&
                    tipoSeleccionado != 'Añadir otro tipo')
                  TextFormField(
                    controller: cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cantidad de crisis ($tipoSeleccionado)",
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese la cantidad de crisis';
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Ingrese un número mayor que cero';
                      }
                      return null;
                    },
                  ),
                if (tipoSeleccionado == 'Añadir otro tipo') ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: "Descripción del tipo",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese la descripción del tipo de crisis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Cantidad",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese la cantidad de crisis';
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Ingrese un número mayor que cero';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton.icon(
          onPressed: _onSave,
          icon: const Icon(Icons.save, color: AppColors.white),
          label: Text(
            isEditing ? "Guardar cambios" : "Guardar",
            style: const TextStyle(color: AppColors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
      ],
    );
  }
}
