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
  Database? _db;

  Future<Database> get database async {
    _db ??= await AppDatabase.getDatabase();
    return _db!;
  }

  @override
  Future<UserModel?> getUserById(int id) async{
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByUsername(String username) {
    // TODO: implement getUserByUsername
    throw UnimplementedError();
  }

  @override
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  @override
  Future<void> updatePassword(String username, String newPasswordHash) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
