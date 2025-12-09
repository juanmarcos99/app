import 'package:app/features/auth/domain/auth_domain.dart';
class LoginUser {
  final UserRepository userRepository;

  LoginUser(this.userRepository);

  Future<int> call(String username, String password) async {
    return await userRepository.loginUser(username, password);
  }
}