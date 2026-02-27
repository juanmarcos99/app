import '../../../auth.dart';

class RememberUser {
  final RememberRepository repository;

  RememberUser(this.repository);

  Future<void> call(String username) {
    return repository.saveUser(username);
  }
}
