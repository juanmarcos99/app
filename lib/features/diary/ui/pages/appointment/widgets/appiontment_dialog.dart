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

    if (selectedDate == null) {
      setState(() {}); 
      return;
    }

    final appointment = Appointment(
      id: null,
      userId: null, 
      information: descriptionController.text.trim(),
      time: selectedDate,
      notificationId: DateTime.now().millisecondsSinceEpoch % 2147483647,
    );
    Navigator.pop(context, appointment);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      // Se adapta al fondo del tema (oscuro o claro)
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Nueva cita médica",
        style: TextStyle(color: colorScheme.onSurface),
      ),
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
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  IconButton(
                    // Usa el color primario del tema
                    icon: Icon(Icons.calendar_today, color: colorScheme.primary),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (selectedDate == null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Debe elegir una fecha",
                    style: TextStyle(color: colorScheme.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                // Estilo de texto que se adapta al fondo
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Ej. Consulta con el Dr. Pérez",
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                  labelText: "Descripción",
                  labelStyle: TextStyle(color: colorScheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "La descripción es requerida";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancelar",
            style: TextStyle(color: colorScheme.primary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary, // Texto en contraste con el botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _onSave,
          child: const Text("Aceptar", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}