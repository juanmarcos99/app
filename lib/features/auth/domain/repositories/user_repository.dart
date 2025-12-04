import 'package:app/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> registerUser(User user);
}
