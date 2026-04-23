import 'package:app/core/core.dart';

class DeleteSyncTaskUseCase {
  final SyncRepository repository;

  DeleteSyncTaskUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteTask(id);
  }
}