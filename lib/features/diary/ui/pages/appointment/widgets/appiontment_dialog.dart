import 'package:flutter/material.dart';
import '../../../../diary.dart';
import 'package:app/core/core.dart';

class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({super.key});
  

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
      title: const Text("Nueva cita médica"),
      content: SizedBox(
        width: double.maxFinite,
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
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ej. Consulta con el Dr. Pérez",
                labelText: "Descripción",
              ),
            ),
          ],
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
          onPressed: () {
            if (selectedDate != null && descriptionController.text.isNotEmpty) {
              final appointment = Appointment(
                id: null,
                userId: null, // ajusta según tu lógica de usuario
                information: descriptionController.text.trim(),
                time: selectedDate,
                notificationId: DateTime.now().millisecondsSinceEpoch % 2147483647,
              );
              Navigator.pop(context, appointment); // devuelve el objeto
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
