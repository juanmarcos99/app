import '../../../auth.dart';

class SavePassword {
  final RememberRepository repository;

  SavePassword(this.repository);

  Future<void> call(String username, String password) {
    return repository.savePassword(username, password);
  }
}
