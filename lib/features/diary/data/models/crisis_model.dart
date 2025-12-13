// data/models/crisis_model.dart
import 'package:app/features/diary/dairy.dart';

class CrisisModel extends Crisis {
  CrisisModel({
    super.id,
    required super.fechaRegistro,
    required super.fechaCrisis,
    required super.usuarioId,
    super.detalles = const [],
  });

  // Convertir a Map para SQLite
  Map<String, dynamic> toMap() => {
        'id': id,
        'fechaRegistro': fechaRegistro.toIso8601String(),
        'fechaCrisis': fechaCrisis.toIso8601String(),
        'usuarioId': usuarioId,
      };

  // Crear modelo desde Map
  factory CrisisModel.fromMap(Map<String, dynamic> map) => CrisisModel(
        id: map['id'] as int?,
        fechaRegistro: DateTime.parse(map['fechaRegistro'] as String),
        fechaCrisis: DateTime.parse(map['fechaCrisis'] as String),
        usuarioId: map['usuarioId'] as int,
      );
}
