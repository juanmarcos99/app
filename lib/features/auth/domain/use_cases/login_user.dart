import 'package:app/features/auth/auth.dart';

class LoginUser {
  final UserRepository userRepository;

  LoginUser(this.userRepository);

  Future<User?> call(String username, String password) async {
    return await userRepository.loginUser(username, password);
  }
}
