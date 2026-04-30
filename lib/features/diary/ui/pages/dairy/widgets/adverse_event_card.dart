import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';

class AdverseEventCard extends StatelessWidget {
  final AdverseEvent adverseEvent;
  final bool isReadOnly;

  const AdverseEventCard({super.key, required this.adverseEvent, this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    int? delayDays;
    if (adverseEvent.registerDate != null && adverseEvent.eventDate != null) {
      final r = DateUtils.dateOnly(adverseEvent.registerDate!);
      final c = DateUtils.dateOnly(adverseEvent.eventDate!);
      delayDays = r.difference(c).inDays;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.surfaceContainerHighest),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.sick, color: cs.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adverseEvent.description ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(adverseEvent.eventDate),
                ),
                if (delayDays != null && delayDays > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 14, color: cs.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Retraso en registro: $delayDays d",
                          style: TextStyle(
                            color: cs.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!isReadOnly)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () async {
                    final result = await showDialog<AdverseEvent>(
                      context: context,
                      useRootNavigator: false,
                      builder: (_) =>
                          RegistroEfectDialog(initialEvent: adverseEvent),
                    );
                    if (result != null) {
                      context.read<DiaryBloc>().add(
                        UpdateAdverseEventEvent(result),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Eliminar evento adverso"),
                        content: const Text(
                          "¿Estás seguro de que deseas eliminar este evento adverso?",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: const Text(
                              "Eliminar",
                              style: TextStyle(color: AppColors.error),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && adverseEvent.id != null) {
                      context.read<DiaryBloc>().add(
                        DeleteAdverseEventEvent(adverseEvent.id!, adverseEvent.userId!),
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

  static String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.year}-${_two(date.month)}-${_two(date.day)}";
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
