import 'package:app/core/core.dart';

class SyncFirstTaskUseCase {
  final SyncRepository repository;

  SyncFirstTaskUseCase(this.repository);

  Future<String> call() async {
    return await repository.syncFirstTask();
  }
}