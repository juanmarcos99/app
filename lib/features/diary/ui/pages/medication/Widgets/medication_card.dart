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

    final isScheduled = await service.isNotificationScheduled(first.notificationId!);

    if (!mounted) return;
    setState(() => notificationsEnabled = isScheduled);
  }

  @override
  Widget build(BuildContext context) {
    final medication = widget.medication;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String frequency = _formatFrequency(
      context,
      medication.schedules ?? [],
    );

    final String notes = medication.notes?.trim().isEmpty == true
        ? "Sin notas"
        : medication.notes!.trim();

    return Container(
      // Alineado con CrisisCard y NotificationCard
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------
              // ÍCONO PREMIUM (Mismo estilo que CrisisCard)
              // ---------------------------------------------------------
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  color: cs.primary,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              // ---------------------------------------------------------
              // INFORMACIÓN
              // ---------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Text(
                      medication.name!,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Frecuencia
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            frequency,
                            style: textTheme.bodySmall!.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Notas
                    Row(
                      children: [
                        Icon(Icons.notes, size: 16, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            notes,
                            style: textTheme.bodySmall!.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: cs.surfaceContainerHighest, height: 1),
          const SizedBox(height: 4),

          // ---------------------------------------------------------
          // ACCIONES
          // ---------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Notificaciones
              _ActionIcon(
                icon: notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                color: notificationsEnabled ? cs.primary : cs.onSurfaceVariant.withOpacity(0.5),
                onPressed: () async {
                  final shouldEnable = !notificationsEnabled;
                  context.read<MedicationBloc>().add(
                        UpdateMedicationEvent(
                          medication,
                          shouldScheduleNotifications: shouldEnable,
                        ),
                      );
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (!mounted) return;
                  _loadNotificationStatus();
                },
              ),

              // Editar
              _ActionIcon(
                icon: Icons.edit,
                color: cs.primary,
                onPressed: () async {
                  final result = await showDialog<(Medication, bool)>(
                    context: context,
                    useRootNavigator: false,
                    builder: (_) => RegisterMedicationDialog(initialMedication: medication),
                  );

                  if (result != null) {
                    context.read<MedicationBloc>().add(
                          UpdateMedicationEvent(
                            result.$1,
                            shouldScheduleNotifications: result.$2,
                          ),
                        );
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (!mounted) return;
                    _loadNotificationStatus();
                  }
                },
              ),

              // Eliminar
              _ActionIcon(
                icon: Icons.delete,
                color: cs.error,
                onPressed: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: cs.surface,
                        title: const Text("Eliminar medicamento"),
                        content: Text("¿Seguro que deseas eliminar \"${medication.name}\"?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: Text("Eliminar", style: TextStyle(color: cs.error)),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    context.read<MedicationBloc>().add(DeleteMedicationEvent(medication.id!));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatFrequency(BuildContext context, List<Schedule> schedules) {
    if (schedules.isEmpty) return "Sin horarios";
    return schedules.map((s) => s.time!.format(context)).join(", ");
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionIcon({required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 22, color: color),
      onPressed: onPressed,
    );
  }
}