import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';

class CrisisCard extends StatelessWidget {
  final Crisis crisis;

  const CrisisCard({super.key, required this.crisis});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.warning, color: AppColors.primary),
        title: Text(
          crisis.type!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${crisis.timeRange} • Cantidad: ${crisis.quantity}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // EDITAR
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
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

            // ELIMINAR
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
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
                        child: const Text(
                          "Eliminar",
                          style: TextStyle(color: Colors.red),
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
      ),
    );
  }
}
