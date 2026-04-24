import 'package:app/features/auth/auth.dart';
abstract class UserRepository {
  //metodos usados en el feature auth
  Future<int> registerUser(User user);   
  Future<User?> loginUser(String username, String password);   
  Future<void> changePassword(String username, String newPassword);  
  Future<int> registerRemoteUser(User user); 
  Future<void> changeRemotePassword(String username, String newPassword);  


//metodos usados en el feature dairy de profile data
  Future<void> updateUser(User user); 
  Future<void> deleteUser(int id);
  Future<void> deleteRemoteUser(int id);
  Future<int?> checkUserExistence(String username);
  Future<void> updateRemoteUser(User user); 
}
