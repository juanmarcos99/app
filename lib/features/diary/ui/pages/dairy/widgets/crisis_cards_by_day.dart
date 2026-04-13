import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';

class CrisisCard extends StatelessWidget {
  final Crisis crisis;

  const CrisisCard({super.key, required this.crisis});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
          // ---------------------------------------------------------
          // ÍCONO PREMIUM
          // ---------------------------------------------------------
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.bolt,
              color: cs.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // ---------------------------------------------------------
          // INFORMACIÓN DE LA CRISIS
          // ---------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  crisis.type ?? "Crisis",
                  style: text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 6),

                // Horario
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      crisis.timeRange ?? "",
                      style: text.bodySmall!.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Cantidad (debajo del horario)
                Row(
                  children: [
                    Icon(Icons.numbers,
                        size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      "Cantidad: ${crisis.quantity}",
                      style: text.bodySmall!.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------
          // ACCIONES (EDITAR / ELIMINAR)
          // ---------------------------------------------------------
          Row(
            children: [
              // EDITAR
              IconButton(
                icon: Icon(Icons.edit, color: cs.primary, size: 22),
                onPressed: () async {
                  final result = await showDialog<Crisis>(
                    context: context,
                    useRootNavigator: false,
                    builder: (_) =>
                        RegisterCrisisDialog(initialCrisis: crisis),
                  );
                  if (result != null) {
                    context.read<DiaryBloc>().add(UpdateCrisisEvent(result));
                  }
                },
              ),

              // ELIMINAR
              IconButton(
                icon: Icon(Icons.delete, color: cs.error, size: 22),
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
                    context.read<DiaryBloc>().add(DeleteCrisisEvent(crisis.id!));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
