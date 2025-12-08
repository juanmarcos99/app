import 'package:app/features/auth/domain/auth_domain.dart';

abstract class UserRepository {
  Future<void> registerUser(User user);
   
}
