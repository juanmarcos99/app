import '../../../../../features/auth/auth.dart';

class UpdateUserRemembered {
  final RememberRepository repository;

  UpdateUserRemembered(this.repository);

  Future<void> call(String oldUsername, String newUsername) {
    return repository.updateRememberedUser(oldUsername, newUsername);
  }
}
