import 'package:app/features/auth/auth.dart';
abstract class UserRepository {
  Future<int> registerUser(User user);   
  Future<User?> loginUser(String username, String password);   
}
