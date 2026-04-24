import 'package:app/features/auth/auth.dart';
import '../../../core.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.localDataSource, this.remoteDataSource);

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
  Future<int> registerRemoteUser(User user) async {
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

    try {
      await remoteDataSource.insertUser(userModel);
    } catch (e) {
      throw ServerException("Error de Sincronización Remota: ($e)");
    }

    return user.id!;
  }

  @override
  Future<UserModel?> loginUser(String username, String password) async {
    // Intentamos local primero

    final localUser = await localDataSource.autentcateUser(username, password);

    if (localUser == null) {
      throw LocalDataBaseException(
        "Usuario no encontrado en el almacenamiento local.",
      );
    }

    try {
      final remoteUser = await remoteDataSource.authenticateUser(
        username,
        password,
      );

      if (remoteUser == null) {
        throw ServerException("Las credenciales no existen en el servidor.");
      }

      return localUser;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("Error de comunicación con el servidor: $e");
    }
  }

  @override
  Future<void> changePassword(String username, String newPassword) async {
    try {
      await localDataSource.updatePassword(username, newPassword);
    } catch (e) {
      throw LocalDataBaseException("Error local al cambiar contraseña: ($e)");
    }

    try {
      await remoteDataSource.updatePassword(username, newPassword);
    } catch (e) {
      throw ServerException("Error remoto al cambiar contraseña: ($e)");
    }
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

    try {
      await localDataSource.updateUser(userModel);
    } catch (e) {
      throw LocalDataBaseException("Error local al actualizar usuario: ($e)");
    }

    try {
      await remoteDataSource.updateUser(userModel);
    } catch (e) {
      throw ServerException("Error remoto al actualizar usuario: ($e)");
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await localDataSource.deleteUser(id);
    } catch (e) {
      throw LocalDataBaseException("Error local al eliminar usuario: ($e)");
    }
  }

  @override
  Future<void> deleteRemoteUser(int id) async {
    try {
      await remoteDataSource.deleteUser(id);
    } catch (e) {
      throw ServerException("Error remoto al eliminar usuario: ($e)");
    }
  }

  @override
  Future<int?> checkUserExistence(String username) async {
    // Primero local
    final localId = await localDataSource.checkUserExistence(username);
    if (localId != null) return localId;

    // Si no existe local, consultamos remoto
    try {
      return await remoteDataSource.checkUserExistence(username);
    } catch (e) {
      // En consultas tipo "check", si falla el remoto devolvemos null
      // para no interrumpir el flujo del usuario
      return null;
    }
  }
}
