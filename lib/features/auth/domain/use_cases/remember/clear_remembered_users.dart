import '../../../auth.dart';

class ClearRememberedUsers {
  final RememberRepository repository;

  ClearRememberedUsers(this.repository);

  Future<void> call() {
    return repository.clearRememberedUsers();
  }
}
