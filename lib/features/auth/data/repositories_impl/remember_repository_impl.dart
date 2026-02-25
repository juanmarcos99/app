import '../../auth.dart';

class RememberRepositoryImpl implements RememberRepository {
  final RememberLocalDataSource local;

  RememberRepositoryImpl(this.local);

  @override
  Future<List<String>> getRememberedUsers() {
    return local.getRememberedUsers();
  }

  @override
  Future<void> saveUser(String username) async {
    final users = await local.getRememberedUsers();
    if (!users.contains(username)) {
      users.add(username);
      await local.saveRememberedUsers(users);
    }
  }

  @override
  Future<void> deleteUser(String username) async {
    final users = await local.getRememberedUsers();
    users.remove(username);
    await local.saveRememberedUsers(users);
    await local.deletePassword(username);
  }

  @override
  Future<void> savePassword(String username, String password) {
    return local.savePassword(username, password);
  }

  @override
  Future<String?> getPassword(String username) {
    return local.getPassword(username);
  }

  @override
  Future<void> clearRememberedUsers() async {
    await local.saveRememberedUsers([]);
  }
}
