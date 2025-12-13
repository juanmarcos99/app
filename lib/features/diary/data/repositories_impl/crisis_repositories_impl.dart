// data/repositories/crisis_repository_impl.dart
import 'package:app/features/diary/data/diary_data.dart';
import 'package:app/features/diary/domain/diary_domain.dart';

class CrisisRepositoryImpl implements CrisisRepository {
  final CrisisLocalDataSource crisisLocal;
  final CrisisDetalleLocalDataSource detalleLocal;

  CrisisRepositoryImpl({
    required this.crisisLocal,
    required this.detalleLocal,
  });

  @override
  Future<int> createCrisis(Crisis crisis) async {
    final crisisModel = CrisisModel(
      id: crisis.id,
      fechaRegistro: crisis.fechaRegistro,
      fechaCrisis: crisis.fechaCrisis,
      usuarioId: crisis.usuarioId,
      detalles: crisis.detalles,
    );
    final crisisId = await crisisLocal.insertCrisis(crisisModel);

    // Insertar detalles si existen
    if (crisis.detalles.isNotEmpty) {
      final detallesModels = crisis.detalles.map((d) => CrisisDetalleModel(
            id: d.id,
            crisisId: crisisId,
            horario: d.horario,
            tipo: d.tipo,
            cantidad: d.cantidad,
          ));
      await detalleLocal.insertMany(detallesModels.toList());
    }
    return crisisId;
  }

  @override
  Future<void> updateCrisis(Crisis crisis) async {
    final crisisModel = CrisisModel(
      id: crisis.id,
      fechaRegistro: crisis.fechaRegistro,
      fechaCrisis: crisis.fechaCrisis,
      usuarioId: crisis.usuarioId,
      detalles: crisis.detalles,
    );
    await crisisLocal.updateCrisis(crisisModel);
  }

  @override
  Future<void> deleteCrisis(int crisisId) async {
    await detalleLocal.deleteByCrisisId(crisisId);
    await crisisLocal.deleteCrisis(crisisId);
  }

  @override
  Future<Crisis?> getCrisisById(int crisisId) async {
    final crisisModel = await crisisLocal.getCrisisById(crisisId);
    if (crisisModel == null) return null;

    final detalles = await detalleLocal.getByCrisisId(crisisId);
    return Crisis(
      id: crisisModel.id,
      fechaRegistro: crisisModel.fechaRegistro,
      fechaCrisis: crisisModel.fechaCrisis,
      usuarioId: crisisModel.usuarioId,
      detalles: detalles,
    );
  }

  @override
  Future<List<Crisis>> getCrisisByDate({
    required int userId,
    required DateTime date,
  }) async {
    final crisisModels = await crisisLocal.getCrisisByUserAndDate(userId, date);
    final result = <Crisis>[];

    for (final crisis in crisisModels) {
      final detalles = await detalleLocal.getByCrisisId(crisis.id!);
      result.add(Crisis(
        id: crisis.id,
        fechaRegistro: crisis.fechaRegistro,
        fechaCrisis: crisis.fechaCrisis,
        usuarioId: crisis.usuarioId,
        detalles: detalles,
      ));
    }
    return result;
  }

  @override
  Future<List<Crisis>> getAllCrisisByUser(int userId) async {
    final crisisModels = await crisisLocal.getCrisisByUser(userId);
    final result = <Crisis>[];

    for (final crisis in crisisModels) {
      final detalles = await detalleLocal.getByCrisisId(crisis.id!);
      result.add(Crisis(
        id: crisis.id,
        fechaRegistro: crisis.fechaRegistro,
        fechaCrisis: crisis.fechaCrisis,
        usuarioId: crisis.usuarioId,
        detalles: detalles,
      ));
    }
    return result;
  }
}
