import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary.dart';

class CrisisCard extends StatelessWidget {
  final Crisis crisis;

  const CrisisCard({super.key, required this.crisis});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.surfaceContainerHighest),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isSmall ? 40 : 48,
                height: isSmall ? 40 : 48,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bolt, color: cs.primary, size: isSmall ? 22 : 28),
              ),

              SizedBox(width: isSmall ? 10 : 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crisis.type ?? "Crisis",
                      style: (isSmall ? text.titleSmall : text.titleMedium)!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            crisis.timeRange ?? "",
                            style: text.bodySmall!.copyWith(
                              color: cs.onSurfaceVariant,
                              fontSize: isSmall ? 11 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(Icons.numbers, size: 14, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          "Cant: ${crisis.quantity}",
                          style: text.bodySmall!.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: isSmall ? 11 : 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: isSmall ? 4 : 8),

              // ACCIONES
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: cs.primary, size: isSmall ? 18 : 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final result = await showDialog<Crisis>(
                        context: context,
                        useRootNavigator: false,
                        builder: (_) => RegisterCrisisDialog(initialCrisis: crisis),
                      );
                      if (result != null) {
                        context.read<DiaryBloc>().add(UpdateCrisisEvent(result));
                      }
                    },
                  ),
                  SizedBox(width: isSmall ? 8 : 12),
                  IconButton(
                    icon: Icon(Icons.delete, color: cs.error, size: isSmall ? 18 : 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Eliminar crisis"),
                          content: const Text(
                            "¿Estás seguro de que deseas eliminar esta crisis?",
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            TextButton(
                              child: Text(
                                "Eliminar",
                                style: TextStyle(color: cs.error),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        context.read<DiaryBloc>().add(
                          DeleteCrisisEvent(crisis.id!, crisis.userId!),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
