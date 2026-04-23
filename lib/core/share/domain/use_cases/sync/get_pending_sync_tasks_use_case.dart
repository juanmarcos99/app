import 'package:app/core/core.dart';

class GetPendingSyncTasksUseCase {
  final SyncRepository repository;

  GetPendingSyncTasksUseCase(this.repository);

  Future<List<SyncTask>> call() async {
    return await repository.getPendingTasks();
  }
}