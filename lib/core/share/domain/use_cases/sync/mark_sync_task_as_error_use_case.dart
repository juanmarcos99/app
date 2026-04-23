import 'package:app/core/core.dart';

class MarkSyncTaskAsErrorUseCase {
  final SyncRepository repository;

  MarkSyncTaskAsErrorUseCase(this.repository);

  Future<void> call(int id, String error) async {
    return await repository.markAsError(id, error);
  }
}