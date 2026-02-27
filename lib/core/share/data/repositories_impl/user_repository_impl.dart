import 'package:app/features/auth/auth.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<int> registerUser(User user) async {
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
    return await localDataSource.insertUser(userModel);
  }

  @override
  Future<UserModel?> loginUser(String username, String password) async {
    return await localDataSource.autentcateUser(username, password);
  }

  @override
  Future<void> changePassword(String username, String newPassword) async {
    return await localDataSource.updatePassword(username, newPassword);
  }

  @override
  Future<void> updateUser(User user) async {
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
    await localDataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(int id) async {
    await localDataSource.deleteUser(id);
  }
}
