import 'package:app/features/auth/auth.dart';
import 'package:app/core/core.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserLocalDataSource {
  Future<int> insertUser(UserModel user);
  Future<UserModel?> getUserById(int id);
  Future<UserModel?> autentcateUser(String username, String password);
  Future<UserModel?> getUserByUsername(String username);
  Future<void> updatePassword(String username, String newPasswordHash);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(int id);
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
    try {
      return await db.insert('users', user.toMap());
    } on DatabaseException catch (e) {
      //Verificamos si el error es por UNIQUE constraint
      if (e.isUniqueConstraintError()) {
        Logger.w("Username ya existe: $e", error: e);
        return -2; // código especial para username duplicado
      } else {
        Logger.e("Error de base de datos: $e", error: e);
        return -1; // otro error
      }
    } catch (e, st) {
      Logger.e("Error inesperado: $e", error: e, stack: st);
      return -1;
    }
  }

  @override
  Future<void> updatePassword(String username, String newPasswordHash) async {
    try {
      final rowsAffected = await db.update(
        'users',
        {'passwordHash': newPasswordHash},
        where: 'userName = ?',
        whereArgs: [username],
      );
      if (rowsAffected == 0) {
        throw Exception(
          "No se pudo actualizar la contraseña: usuario '$username' no existe",
        );
      }
    } catch (e) {
      // Captura cualquier otro error inesperado
      throw Exception("Error al actualizar contraseña: $e");
    }
  }

  @override
  Future<UserModel?> autentcateUser(String username, String password) async {
    final user = await getUserByUsername(username);
    if (user != null && user.passwordHash == password) {
      return user; // Login exitoso
    }
    return null; // Credenciales inválidas
  }

//metodo usado en el feature dairy (profile data)
  @override
  Future<void> updateUser(UserModel user) async {
  try {
    final rowsAffected = await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    if (rowsAffected == 0) {
      throw Exception("No se pudo actualizar: usuario con id ${user.id} no existe");
    }
  } catch (e) {
    throw Exception("Error al actualizar usuario: $e");
  }
}

@override
Future<void> deleteUser(int id) async {
  try {
    final rowsAffected = await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (rowsAffected == 0) {
      throw Exception("No se pudo eliminar: usuario con id $id no existe");
    }
  } catch (e) {
    throw Exception("Error al eliminar usuario: $e");
  }
}


}
