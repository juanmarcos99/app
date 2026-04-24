import 'package:app/features/auth/auth.dart';

class DeleteRemoteUser {
  final UserRepository repository;

  DeleteRemoteUser(this.repository);

  Future<void> call(int id) {
    return repository.deleteRemoteUser(id);
  }
}
