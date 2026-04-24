import 'package:app/core/core.dart';

class GetPendingSyncTasksByUserIdUseCase {
  final SyncRepository repository;

  GetPendingSyncTasksByUserIdUseCase(this.repository);

  Future<List<SyncTask>> call(int userId) async {
    return await repository.getPendingTasksByUserId(userId);
  }
}