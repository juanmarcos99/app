import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    const Color statusColor = Colors.green;
    const String statusText = "ACTIVO";

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
          // (1) Estado
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // (2) Nombre del medicamento
          Text(
            medication.name!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101519),
            ),
          ),

          const SizedBox(height: 10),

          // (3) Frecuencia
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Frecuencia: $frequency",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  softWrap: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // (4) Notas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notes, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Notas: $notes",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  softWrap: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // (5) Footer con acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // NOTIFICACIONES
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  size: 22,
                  color: Colors.grey,
                ),
                onPressed: () {
                  debugPrint(
                    "Toggle notifications for medication ${medication.id}",
                  );
                },
              ),

              const SizedBox(width: 4),

              // EDITAR
              IconButton(
                icon: const Icon(Icons.edit, size: 22, color: Colors.grey),
                onPressed: () async {
                  final result = await showDialog<Medication>(
                    context: context,
                    useRootNavigator: false,
                    builder: (_) =>
                        RegisterMedicationDialog(initialMedication: medication),
                  );
                  if (result != null) {
                    context.read<MedicationBloc>().add(
                      UpdateMedicationEvent(result),
                    );
                  }
                },
              ),

              const SizedBox(width: 4),

              // ELIMINAR (con confirmación)
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

  /// Ahora recibe List< Schedule> en lugar de List<String>
  String _formatFrequency(BuildContext context, List<Schedule> schedules) {
    if (schedules.isEmpty) return "Sin horarios";
    return schedules
        .map(
          (s) =>
              s.time != null ? s.time!.format(context) : "Horario no definido",
        )
        .join(", ");
  }
}
