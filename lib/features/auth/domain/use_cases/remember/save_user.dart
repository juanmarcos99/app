import '../../../auth.dart';

class SaveUser {
  final RememberRepository repository;

  SaveUser(this.repository);

  Future<void> call(String username) {
    return repository.saveUser(username);
  }
}
