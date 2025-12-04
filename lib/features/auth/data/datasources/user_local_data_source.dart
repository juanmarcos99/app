import 'package:app/features/auth/data/models/user_model.dart';
import 'package:app/core/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserLocalDataSource {
  Future<int> insertUser(UserModel user);
  Future<UserModel?> getUserById(int id);
  Future<UserModel?> getUserByUsername(String username);
  Future<void> updatePassword(String username, String newPasswordHash);
}

// implementar la clase me permite cambiar de DB sin q se rompa el codigo
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
  Future<void> updatePassword(String username, String newPasswordHash) async{
    await db.update(
      'users',
      {'passwordHash': newPasswordHash},
      where: 'userName = ?',
      whereArgs: [username],
    );
  }
}
