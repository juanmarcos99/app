import 'package:app/features/auth/auth.dart';

class ChangeRemotePasswordUseCase {
  final UserRepository userRepository;

  ChangeRemotePasswordUseCase(this.userRepository);

  Future<void> call(String username, String newPassword) async {
    return await userRepository.changeRemotePassword(username, newPassword);
  }
}
