import '../../diary.dart';

class CrisisRepositoryImpl implements CrisisRepository {
  final CrisisLocalDataSource localDataSource;

  CrisisRepositoryImpl(this.localDataSource);

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
}
