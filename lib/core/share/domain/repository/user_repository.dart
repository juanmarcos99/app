import 'package:app/features/auth/auth.dart';
abstract class UserRepository {
  //metodos usados en el feature auth
  Future<int> registerUser(User user);   
  Future<User?> loginUser(String username, String password);   
  Future<void> changePassword(String username, String newPassword);   
//metodos usados en el feature dairy de profile data
  Future<void> updateUser(User user); 
  Future<void> deleteUser(int id);
}
