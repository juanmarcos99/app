import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';

class RegisterMedicationDialog extends StatefulWidget {
  final Medication? initialMedication; // null = registrar, no null = editar

  const RegisterMedicationDialog({super.key, this.initialMedication});

  @override
  State<RegisterMedicationDialog> createState() => _RegisterMedicationDialogState();
}

class _RegisterMedicationDialogState extends State<RegisterMedicationDialog> {
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final notesController = TextEditingController();

  /// Ahora usamos objetos Schedule en lugar de Strings
  List<Schedule> selectedSchedules = [];

  bool get isEditing => widget.initialMedication != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final med = widget.initialMedication!;
      nameController.text = med.name!;
      dosageController.text = med.dosage!;
      notesController.text = med.notes ?? " ";
      selectedSchedules = List<Schedule>.from(med.schedules!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _addSchedule() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        // Creamos un Schedule con el horario seleccionado
        selectedSchedules.add(
          Schedule(
            id: null, // se asignará al guardar en BD
            medicationId: widget.initialMedication?.id ?? 0,
            time: picked,
            notificationId: 0, // se asignará al programar notificación
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(isEditing ? "Editar Medicación" : "Registrar Medicación"),

      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.55,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // NOMBRE
              const Text("Nombre del medicamento", style: TextStyle(fontSize: 16)),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ej: Paracetamol",
                ),
              ),
              const SizedBox(height: 20),

              // DOSIS
              const Text("Dosis", style: TextStyle(fontSize: 16)),
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ej: 500 mg",
                ),
              ),
              const SizedBox(height: 20),

              // NOTAS
              const Text("Notas (opcional)", style: TextStyle(fontSize: 16)),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ej: Tomar con comida",
                ),
              ),
              const SizedBox(height: 20),

              // HORARIOS
              const Text("Horarios", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: selectedSchedules.map((schedule) {
                  final formatted = schedule.time?.format(context);
                  return Chip(
                    label: Text(formatted!),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        selectedSchedules.remove(schedule);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _addSchedule,
                icon: const Icon(Icons.add),
                label: const Text("Añadir horario"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
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
            final medication = Medication(
              id: widget.initialMedication?.id,
              userId: widget.initialMedication?.userId,
              name: nameController.text.trim(),
              dosage: dosageController.text.trim(),
              notes: notesController.text.trim(),
              schedules: selectedSchedules, // ahora es List<Schedule>
            );

            Navigator.pop(context, medication);
          },
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
