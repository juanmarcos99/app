import '../../../auth.dart';

class DeleteUser {
  final RememberRepository repository;

  DeleteUser(this.repository);

  Future<void> call(String username) {
    return repository.deleteUser(username);
  }
}
