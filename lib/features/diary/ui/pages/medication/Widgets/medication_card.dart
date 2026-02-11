import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary.dart';


class MedicationCard extends StatefulWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStatus();
  }

  /// 🔥 Consulta REAL del estado de notificaciones
  Future<void> _loadNotificationStatus() async {
    final service = NotificationService();

    final schedules = widget.medication.schedules;
    if (schedules == null || schedules.isEmpty) {
      if (!mounted) return;
      setState(() => notificationsEnabled = false);
      return;
    }

    final first = schedules.first;

    if (first.notificationId == null) {
      if (!mounted) return;
      setState(() => notificationsEnabled = false);
      return;
    }

    final isScheduled =
        await service.isNotificationScheduled(first.notificationId!);

    if (!mounted) return;
    setState(() => notificationsEnabled = isScheduled);
  }

  @override
  Widget build(BuildContext context) {
    final medication = widget.medication;

    final String frequency = _formatFrequency(
      context,
      medication.schedules ?? [],
    );

    final String notes = medication.notes?.trim().isEmpty == true
        ? "Sin notas"
        : medication.notes!.trim();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre
          Text(
            medication.name!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101519),
            ),
          ),

          const SizedBox(height: 10),

          // Frecuencia
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Frecuencia: $frequency",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Notas
          Row(
            children: [
              Icon(Icons.notes, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Notas: $notes",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              // 🔔 Toggle notificaciones
              IconButton(
                icon: Icon(
                  notificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  size: 22,
                  color: notificationsEnabled ? Colors.blue : Colors.grey,
                ),
                onPressed: () async {
                  final shouldEnable = !notificationsEnabled;

                  context.read<MedicationBloc>().add(
                        UpdateMedicationEvent(
                          medication,
                          shouldScheduleNotifications: shouldEnable,
                        ),
                      );

                  // Esperar a que el BLoC actualice BD y notificaciones
                  await Future.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return;
                  _loadNotificationStatus();
                },
              ),

              const SizedBox(width: 4),

              // ✏️ Editar
              IconButton(
                icon: const Icon(Icons.edit, size: 22, color: Colors.grey),
                onPressed: () async {
                  final result = await showDialog<(Medication, bool)>(
                    context: context,
                    useRootNavigator: false,
                    builder: (_) =>
                        RegisterMedicationDialog(initialMedication: medication),
                  );

                  if (result != null) {
                    final updatedMedication = result.$1;
                    final shouldSchedule = result.$2;

                    context.read<MedicationBloc>().add(
                      UpdateMedicationEvent(
                        updatedMedication,
                        shouldScheduleNotifications: shouldSchedule,
                      ),
                    );

                    await Future.delayed(const Duration(milliseconds: 300));
                    if (!mounted) return;
                    _loadNotificationStatus();
                  }
                },
              ),

              const SizedBox(width: 4),

              // 🗑️ Eliminar
              IconButton(
                icon: const Icon(Icons.delete, size: 22, color: Colors.red),
                onPressed: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Eliminar medicamento"),
                        content: Text(
                          "¿Seguro que deseas eliminar \"${medication.name}\"?\n"
                          "Esta acción no se puede deshacer.",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              "Eliminar",
                              style: TextStyle(color: AppColors.white),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    context.read<MedicationBloc>().add(
                      DeleteMedicationEvent(medication.id!),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Formatear horarios
  String _formatFrequency(BuildContext context, List<Schedule> schedules) {
    if (schedules.isEmpty) return "Sin horarios";
    return schedules
        .map((s) => s.time!.format(context))
        .join(", ");
  }
}
