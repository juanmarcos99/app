// domain/usecases/register_crisis.dart
import '../../entities/crisis.dart';
import '../../repositories/crisis_repository.dart';

class RegisterCrisis {
  final CrisisRepository repository;

  RegisterCrisis(this.repository);

  Future<int> call(Crisis crisis) async {
    // Validaciones de negocio
    if (crisis.detalles.isEmpty) {
      throw Exception("Debe registrar al menos un detalle de crisis");
    }
    if (crisis.fechaCrisis.isAfter(DateTime.now())) {
      throw Exception("No se pueden registrar crisis en fechas futuras");
    }

    return await repository.createCrisis(crisis);
  }
}
