import 'package:app/features/diary/diary.dart';

class GetLastCrisisDayByUser {
  final CrisisRepository repository;

  GetLastCrisisDayByUser(this.repository);

  Future<DateTime?> call(int userId) async {
    return await repository.getLastCrisisDayByUser(userId);
  }
}
