import 'package:app/features/auth/auth.dart';
class RegisterRemoteUser {
  final UserRepository repository;
  RegisterRemoteUser(this.repository);
  Future <int> call (User user)async{
    return repository.registerRemoteUser(user);
  }
}