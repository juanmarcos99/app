import 'package:flutter/material.dart';
import '../../../../diary.dart';
import '../../../../../../core/core.dart';


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

  List<Schedule> selectedSchedules = [];

  /// Switch para activar/desactivar notificaciones
  bool shouldScheduleNotifications = true;

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

      /// 🔥 Aquí verificamos si ya hay notificaciones programadas
      _loadNotificationStatus();
    }
  }

  /// 🔥 Verifica si las notificaciones están programadas para este medicamento
  Future<void> _loadNotificationStatus() async {
    if (selectedSchedules.isEmpty) return;

    final firstSchedule = selectedSchedules.first;

    // Si notificationId es null, no puede estar programada
    if (firstSchedule.notificationId == null) {
      setState(() => shouldScheduleNotifications = false);
      return;
    }

    final service = NotificationService();
    final isScheduled = await service.isNotificationScheduled(firstSchedule.notificationId!);

    setState(() {
      shouldScheduleNotifications = isScheduled;
    });
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
        selectedSchedules.add(
          Schedule(
            id: null,
            medicationId: widget.initialMedication?.id ?? 0,
            time: picked,
            notificationId: DateTime.now().millisecondsSinceEpoch % 2147483647,
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
        height: MediaQuery.of(context).size.height * 0.60,
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

              // SWITCH DE NOTIFICACIONES
              Row(
                children: [
                  Switch(
                    value: shouldScheduleNotifications,
                    onChanged: (v) {
                      setState(() => shouldScheduleNotifications = v);
                    },
                  ),
                  const Text(
                    "Programar notificaciones",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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
              schedules: selectedSchedules,
            );

            Navigator.pop(context, (medication, shouldScheduleNotifications));
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
