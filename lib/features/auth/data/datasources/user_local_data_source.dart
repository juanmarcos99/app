import 'package:app/features/auth/data/auth_data.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserLocalDataSource {
  Future<int> insertUser(UserModel user);
  Future<UserModel?> getUserById(int id);
  Future<UserModel?> getUserByUsername(String username);
  Future<void> updatePassword(String username, String newPasswordHash);
}



// permite cambiar de DB sin q se afecte la app
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database db;

  UserLocalDataSourceImpl(this.db);

  @override
  Future<UserModel?> getUserById(int id) async {
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    final result = await db.query(
      'users',
      where: 'userName = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> insertUser(UserModel user) async {
    return await db.insert('users', user.toMap());
  }

  @override
  Future<void> updatePassword(String username, String newPasswordHash) async {
    await db.update(
      'users',
      {'passwordHash': newPasswordHash},
      where: 'userName = ?',
      whereArgs: [username],
    );
  }
}
