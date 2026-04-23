import 'package:app/core/core.dart';

class AddToSyncQueueUseCase {
  final SyncRepository repository;

  AddToSyncQueueUseCase(this.repository);

  Future<void> call(SyncTask task) async {
    return await repository.addToQueue(task);
  }
}