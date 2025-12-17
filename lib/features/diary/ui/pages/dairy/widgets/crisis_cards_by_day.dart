import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class CrisisCardsByDay extends StatelessWidget {
  final String tipo;
  final String horario;
  final int cantidad;
  final DateTime fecha;

  const CrisisCardsByDay({
    super.key,
    required this.tipo,
    required this.horario,
    required this.cantidad,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.warning, color: AppColors.primary),
        title: Text(tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$horario • Cantidad: $cantidad"),
        trailing: Text(
          "${fecha.day}/${fecha.month}/${fecha.year}",
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
