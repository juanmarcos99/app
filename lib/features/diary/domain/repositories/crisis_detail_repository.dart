// domain/repositories/crisis_detail_repository.dart
import '../entities/crisis_detail.dart';

abstract class CrisisDetailRepository {
  Future<int> addDetail(CrisisDetalle detalle);
  Future<void> addMany(List<CrisisDetalle> detalles);
  Future<void> updateDetail(CrisisDetalle detalle);
  Future<void> deleteDetail(int detalleId);
  Future<void> deleteByCrisisId(int crisisId);

  Future<List<CrisisDetalle>> getByCrisisId(int crisisId);
}
