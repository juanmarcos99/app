import 'package:app/features/auth/auth.dart';
class RegisterUser {
  final UserRepository repository;
  RegisterUser(this.repository);
  Future <int> call (User user)async{
    return repository.registerUser(user);
  }
}