import 'package:app/features/auth/auth.dart';

class CheckUserExistence {
  final UserRepository userRepository;

  CheckUserExistence(this.userRepository);

  Future<int?> call(String username) async {
    return await userRepository.checkUserExistence(username);
  }
}
