import 'package:flutter/material.dart';
import '../../../../diary.dart';
import '../../../../../../core/core.dart';

class RegisterMedicationDialog extends StatefulWidget {
  final Medication? initialMedication; 

  const RegisterMedicationDialog({super.key, this.initialMedication});

  @override
  State<RegisterMedicationDialog> createState() => _RegisterMedicationDialogState();
}

class _RegisterMedicationDialogState extends State<RegisterMedicationDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final notesController = TextEditingController();

  List<Schedule> selectedSchedules = [];
  bool shouldScheduleNotifications = true;

  bool get isEditing => widget.initialMedication != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final med = widget.initialMedication!;
      nameController.text = med.name ?? '';
      dosageController.text = med.dosage ?? '';
      notesController.text = med.notes ?? '';
      selectedSchedules = List<Schedule>.from(med.schedules ?? []);
      _loadNotificationStatus();
    }
  }

  Future<void> _loadNotificationStatus() async {
    if (selectedSchedules.isEmpty) return;
    final firstSchedule = selectedSchedules.first;
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

  void _onSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final medication = Medication(
      id: widget.initialMedication?.id,
      userId: widget.initialMedication?.userId,
      name: nameController.text.trim(),
      dosage: dosageController.text.trim(),
      notes: notesController.text.trim(),
      schedules: selectedSchedules,
    );

    Navigator.pop(context, (medication, shouldScheduleNotifications));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        isEditing ? "Editar Medicación" : "Registrar Medicación",
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Nombre del medicamento", cs),
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration("Ej: Paracetamol", cs),
                  style: TextStyle(color: cs.onSurface),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Requerido" : null,
                ),
                const SizedBox(height: 16),

                _buildLabel("Dosis", cs),
                TextFormField(
                  controller: dosageController,
                  decoration: _inputDecoration("Ej: 500 mg", cs),
                  style: TextStyle(color: cs.onSurface),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Requerido" : null,
                ),
                const SizedBox(height: 16),

                _buildLabel("Notas (opcional)", cs),
                TextFormField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: _inputDecoration("Ej: Tomar con comida", cs),
                  style: TextStyle(color: cs.onSurface),
                ),
                const SizedBox(height: 16),

                // Switch de notificaciones con estilo
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: Text("Programar notificaciones", style: textTheme.bodyMedium),
                    value: shouldScheduleNotifications,
                    activeColor: cs.primary,
                    onChanged: (v) => setState(() => shouldScheduleNotifications = v),
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel("Horarios", cs),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ...selectedSchedules.map((schedule) {
                      final formatted = schedule.time?.format(context);
                      return Chip(
                        label: Text(formatted!, style: TextStyle(color: cs.onSecondaryContainer)),
                        backgroundColor: cs.secondaryContainer,
                        deleteIcon: Icon(Icons.close, size: 16, color: cs.onSecondaryContainer),
                        onDeleted: () => setState(() => selectedSchedules.remove(schedule)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }),
                    ActionChip(
                      avatar: Icon(Icons.add, size: 18, color: cs.onPrimary),
                      label: Text("Añadir", style: TextStyle(color: cs.onPrimary)),
                      backgroundColor: cs.primary,
                      onPressed: _addSchedule,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: TextStyle(color: cs.primary)),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(isEditing ? "Guardar cambios" : "Guardar"),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, ColorScheme cs) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cs.onSurfaceVariant.withOpacity(0.5)),
      filled: true,
      fillColor: cs.surfaceContainerHighest.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
    );
  }
}