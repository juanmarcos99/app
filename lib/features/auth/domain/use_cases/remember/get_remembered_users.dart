import '../../../auth.dart';

class GetRememberedUsers {
  final RememberRepository repository;

  GetRememberedUsers(this.repository);

  Future<List<String>> call() {
    return repository.getRememberedUsers();
  }
}
