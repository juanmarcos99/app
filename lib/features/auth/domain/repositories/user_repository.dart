import 'package:app/features/auth/domain/auth_domain.dart';

abstract class UserRepository {
  Future<int> registerUser(User user);   
  Future<User?> loginUser(String username, String password);   
}
