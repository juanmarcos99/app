import 'package:app/core/core.dart';
import 'package:app/core/share/data/datasources/remote_data_sourse/crisis_remote_data_source.dart';
import '../../diary.dart';

class CrisisRepositoryImpl implements CrisisRepository {
  final CrisisLocalDataSource localDataSource;
  final CrisisRemoteDataSource remoteDataSource;

  CrisisRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<void> addCrisis(Crisis crisis) async {
    final model = CrisisModel(
      id: crisis.id,
      registeredDate: crisis.registeredDate,
      crisisDate: crisis.crisisDate,
      timeRange: crisis.timeRange,
      quantity: crisis.quantity,
      type: crisis.type,
      userId: crisis.userId,
    );
    await localDataSource.addCrisis(model);
  }

  //para las tarjetas de crisis
  @override
  Future<List<Crisis>> getCrisesByDayAndUser(DateTime day, int userId) async {
    final result = await localDataSource.getCrisisByDateAndUser(day, userId);
    return result; // CrisisModel hereda de Crisis, así que puedes devolverlo directamente
  }

  //para el calendario
  @override
  Future<List<DateTime>> getCrisesDaysByUser(int userId) async {
    final result = await localDataSource.getCrisisDaysByUser(userId);
    return result;
  }

  @override
  Future<void> deleteCrisis(int crisisId) async {
    await localDataSource.deleteCrisis(crisisId);
  }

  @override
  Future<void> updateCrisis(Crisis crisis) async {
    final model = CrisisModel(
      id: crisis.id,
      registeredDate: crisis.registeredDate,
      crisisDate: crisis.crisisDate,
      timeRange: crisis.timeRange,
      quantity: crisis.quantity,
      type: crisis.type,
      userId: crisis.userId,
    );
    await localDataSource.updateCrisis(model);
  }

  @override
  Future<List<Crisis>> getCrisesByMonthAndYear(
    int month,
    int year,
    int userId,
  ) async {
    final result = await localDataSource.getCrisisByMonthAndYear(
      month,
      year,
      userId,
    );
    return result;
  }

  // obtener el último día con crisis
  @override
  Future<DateTime?> getLastCrisisDayByUser(int userId) async {
    return await localDataSource.getLastCrisisDayByUser(userId);
  }

  @override
  Future<void> addRemoteCrisis(Crisis crisis) async {
    final model = CrisisModel(
      id: crisis.id,
      registeredDate: crisis.registeredDate,
      crisisDate: crisis.crisisDate,
      timeRange: crisis.timeRange,
      quantity: crisis.quantity,
      type: crisis.type,
      userId: crisis.userId,
    );
    try {
      await remoteDataSource.addCrisis(model);
    } catch (e) {
      throw ServerException("Error remoto al añadir crisis: ($e)");
    }
  }

  @override
  Future<void> updateRemoteCrisis(Crisis crisis) async {
    final model = CrisisModel(
      id: crisis.id,
      registeredDate: crisis.registeredDate,
      crisisDate: crisis.crisisDate,
      timeRange: crisis.timeRange,
      quantity: crisis.quantity,
      type: crisis.type,
      userId: crisis.userId,
    );
    try {
      await remoteDataSource.updateCrisis(model);
    } catch (e) {
      throw ServerException("Error remoto al actualizar crisis: ($e)");
    }
  }

  @override
  Future<void> deleteRemoteCrisis(int crisisId) async {
    try {
      await remoteDataSource.deleteCrisis(crisisId);
    } catch (e) {
      throw ServerException("Error remoto al eliminar crisis: ($e)");
    }
  }
}
