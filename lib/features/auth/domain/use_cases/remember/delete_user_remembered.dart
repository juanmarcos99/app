import '../../../auth.dart';

class DeleteUserRemembered {
  final RememberRepository repository;

  DeleteUserRemembered(this.repository);

  Future<void> call(String username) {
    return repository.deleteUser(username);
  }
}
