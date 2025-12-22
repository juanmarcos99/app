import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class AdverseEventCard extends StatelessWidget {
  final String descripcion;
  final DateTime fecha;
  final DateTime fechaRegistro;

  const AdverseEventCard({
    super.key,
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
                // 🔥 Aquí irá la funcionalidad de editar evento adverso
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // 🔥 Aquí irá la funcionalidad de eliminar evento adverso
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
