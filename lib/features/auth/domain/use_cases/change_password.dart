import 'package:app/features/auth/auth.dart';

class ChangePassword {
  final UserRepository userRepository;

  ChangePassword(this.userRepository);

  Future<void> call(String username, String newPassword) async {
    return await userRepository.changePassword(username, newPassword);
  }
}
