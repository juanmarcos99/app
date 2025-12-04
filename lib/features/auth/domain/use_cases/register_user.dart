import 'package:app/features/auth/domain/entities/user.dart';
import 'package:app/features/auth/domain/repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;
  RegisterUser(this.repository);
  Future <void> call (User user)async{
    await repository.registerUser(user);
  }

}