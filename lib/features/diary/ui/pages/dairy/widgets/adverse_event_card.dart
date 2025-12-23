import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';

class AdverseEventCard extends StatelessWidget {
  final AdverseEvent adverseEvent;

  const AdverseEventCard({super.key, required this.adverseEvent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.error_outline, color: AppColors.primary),
        title: Text(
          adverseEvent.description ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${_formatDate(adverseEvent.eventDate)} • Registrado: ${_formatDate(adverseEvent.registerDate)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // EDITAR
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final result = await showDialog<AdverseEvent>(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) =>
                      RegistroEfectDialog(initialEvent: adverseEvent),
                );

                if (result != null) {
                  context
                      .read<DiaryBloc>()
                      .add(UpdateAdverseEventEvent(result));
                }
              },
            ),

            // ELIMINAR
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
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
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );

                if (confirm == true && adverseEvent.id != null) {
                  context.read<DiaryBloc>().add(
                    DeleteAdverseEventEvent(adverseEvent.id!),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.year}-${_two(date.month)}-${_two(date.day)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
