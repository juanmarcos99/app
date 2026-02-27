import 'package:app/features/auth/auth.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(User user) {
    return repository.updateUser(user);
  }
}
