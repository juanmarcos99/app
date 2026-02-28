import 'package:app/core/core.dart';

abstract class RememberLocalDataSource {
  Future<List<String>> getRememberedUsers();
  Future<void> saveRememberedUsers(List<String> users);
  Future<void> deleteRememberedUser(String username);

  Future<void> savePassword(String username, String password);
  Future<String?> getPassword(String username);

  Future<void> deletePassword(String username);
  Future<void> updateRememberedUser(String oldUsername, String newUsername);
}

class RememberLocalDataSourceImpl implements RememberLocalDataSource {
  final StorageService storage;

  RememberLocalDataSourceImpl(this.storage);

  @override
  Future<List<String>> getRememberedUsers() async {
    return await storage.getStringList('remembered_users') ?? [];
  }

  @override
  Future<void> saveRememberedUsers(List<String> users) async {
    await storage.saveStringList('remembered_users', users);
  }

  @override
  Future<void> deleteRememberedUser(String username) async {
    await storage.removeFromStringList('remembered_users', username);
  }

  @override
  Future<void> savePassword(String username, String password) async {
    await storage.saveSecure('password_$username', password);
  }

  @override
  Future<String?> getPassword(String username) async {
    return await storage.getSecure('password_$username');
  }

  @override
  Future<void> deletePassword(String username) async {
    await storage.deleteSecure('password_$username');
  }

  @override
  Future<void> updateRememberedUser(
    String oldUsername,
    String newUsername,
  ) async {
    await storage.updateInStringList(
      'remembered_users',
      oldUsername,
      newUsername,
    );
  }
}
