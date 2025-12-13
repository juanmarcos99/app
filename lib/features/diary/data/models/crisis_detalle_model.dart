// data/models/crisis_detalle_model.dart
import 'package:app/features/diary/dairy.dart';

class CrisisDetalleModel extends CrisisDetalle {
  CrisisDetalleModel({
    super.id,
    required super.crisisId,
    required super.horario,
    required super.tipo,
    required super.cantidad,
  });

  // Convertir a Map para SQLite
  Map<String, dynamic> toMap() => {
        'id': id,
        'crisisId': crisisId,
        'horario': horario,
        'tipo': tipo,
        'cantidad': cantidad,
      };

  // Crear modelo desde Map
  factory CrisisDetalleModel.fromMap(Map<String, dynamic> map) =>
      CrisisDetalleModel(
        id: map['id'] as int?,
        crisisId: map['crisisId'] as int,
        horario: map['horario'] as String,
        tipo: map['tipo'] as String,
        cantidad: map['cantidad'] as int,
      );
}
