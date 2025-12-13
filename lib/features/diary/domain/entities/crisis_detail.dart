class CrisisDetalle {
  final int? id;
  final int crisisId;       // relación con Crisis
  final String horario;     // ej. "6:00 am - 10:00 am"
  final String tipo;        // ej. "Focales conscientes"
  final int cantidad;       // número de crisis en ese horario

  CrisisDetalle({
    this.id,
    required this.crisisId,
    required this.horario,
    required this.tipo,
    required this.cantidad,
  });
}
