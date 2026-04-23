import 'package:app/core/core.dart';

class ProcessFullSyncQueueUseCase {
  final SyncRepository repository;

  ProcessFullSyncQueueUseCase(this.repository);

  Future<void> call() async {
    return await repository.processFullQueue();
  }
}