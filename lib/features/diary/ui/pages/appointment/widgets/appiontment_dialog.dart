import 'package:flutter/material.dart';
import 'package:app/core/core.dart'; 
import 'package:app/features/auth/auth.dart'; 

class AppointmentDialog extends StatefulWidget {
  final Function(DateTime, String) onConfirm;

  const AppointmentDialog({super.key, required this.onConfirm});

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Nuevo turno médico",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector de fecha
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

            // Campo de descripción
            CustomTextField(
              label: "Descripción",
              hint: "Ej. Consulta con el Dr. Pérez",
              icon: Icons.description,
              controller: descriptionController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancelar",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (selectedDate != null && descriptionController.text.isNotEmpty) {
              widget.onConfirm(selectedDate!, descriptionController.text);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Debes elegir fecha y escribir descripción"),
                ),
              );
            }
          },
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
