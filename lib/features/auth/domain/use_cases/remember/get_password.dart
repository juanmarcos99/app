import '../../../auth.dart';

class GetPassword {
  final RememberRepository repository;

  GetPassword(this.repository);

  Future<String?> call(String username) {
    return repository.getPassword(username);
  }
}
