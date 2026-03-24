import 'package:flutter/material.dart';
import '../../../../diary.dart';
import 'package:app/core/core.dart';

class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({super.key});

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final appointment = Appointment(
      id: null,
      userId: null, // ajusta según tu lógica de usuario
      information: descriptionController.text.trim(),
      time: selectedDate,
      notificationId: DateTime.now().millisecondsSinceEpoch % 2147483647,
    );
    Navigator.pop(context, appointment);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Nueva cita médica"),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "No has elegido fecha"
                          : "Fecha: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: AppColors.primary),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ej. Consulta con el Dr. Pérez",
                  labelText: "Descripción",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "La descripción es requerida";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Validación de fecha seleccionada
              if (selectedDate == null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Debe elegir una fecha",
                    style: TextStyle(color: Colors.red, fontSize: 12),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _onSave,
          child: const Text("Aceptar", style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
