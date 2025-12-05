import 'package:app/features/auth/data/auth_data.dart';
import 'package:app/features/auth/domain/auth_domain.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> registerUser(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      userName: user.userName,
      passwordHash: user.passwordHash,
      role: user.role,
    );
    await localDataSource.insertUser(userModel);
  }
}
