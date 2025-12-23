import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart'; 

class AdverseEventCard extends StatelessWidget {
  final int id;
  final String descripcion;
  final DateTime fecha;
  final DateTime fechaRegistro;

  const AdverseEventCard({
    super.key,
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.fechaRegistro,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.error_outline, color: AppColors.primary),
        title: Text(
          descripcion,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${_formatDate(fecha)} • Registrado: ${_formatDate(fechaRegistro)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Aquí irá la funcionalidad de editar evento adverso
              },
            ),

            //  BOTÓN ELIMINAR
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

                if (confirm == true) {
                  context
                      .read<DiaryBloc>()
                      .add(DeleteAdverseEventEvent(id));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${_two(date.month)}-${_two(date.day)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
