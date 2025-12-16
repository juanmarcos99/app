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
    await localDataSource.insertCrisis(model);
  }

  // otros métodos se implementarán más adelante según necesidad
}
