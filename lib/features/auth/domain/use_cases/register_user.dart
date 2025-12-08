import 'package:app/features/auth/domain/auth_domain.dart';

class RegisterUser {
  final UserRepository repository;
  RegisterUser(this.repository);
  Future <void> call (User user)async{
    await repository.registerUser(user);
  }
}