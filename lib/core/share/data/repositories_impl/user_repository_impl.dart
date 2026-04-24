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
    final localUser = await localDataSource.autentcateUser(username, password);

    if (localUser == null) {
      throw LocalDataBaseException(
        "Usuario no encontrado en el almacenamiento local.",
      );
    }

    return localUser;
  }

  @override
  Future<void> changePassword(String username, String newPassword) async {
    try {
      await localDataSource.updatePassword(username, newPassword);
    } catch (e) {
      throw LocalDataBaseException("Error local al cambiar contraseña: ($e)");
    }
  }

  @override
  Future<void> changeRemotePassword(String username, String newPassword) async {
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

  @override
  Future<void> updateRemoteUser(User user) async {
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
      // Intentamos la actualización en la fuente de datos remota (Supabase)
      await remoteDataSource.updateUser(userModel);
    } catch (e) {
      // Si falla lanzamos ServerException
      throw ServerException("Error remoto al actualizar usuario: ($e)");
    }
  }
}
