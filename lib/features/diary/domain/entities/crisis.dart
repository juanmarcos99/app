import 'crisis_detail.dart';
class Crisis {
  final int? id;
  final DateTime fechaRegistro; // cuándo se registró en el sistema
  final DateTime fechaCrisis;   // día en que ocurrió la crisis
  final int usuarioId;          // quién registró la crisis
  final List<CrisisDetalle> detalles; // lista de episodios asociados

  Crisis({
    this.id,
    required this.fechaRegistro,
    required this.fechaCrisis,
    required this.usuarioId,
    required this.detalles,
  });
}
