import 'package:app/features/auth/auth.dart';

class UpdateRemoteUser {
  final UserRepository repository;

  UpdateRemoteUser(this.repository);

  Future<void> call(User user) {
    return repository.updateRemoteUser(user);
  }
}
