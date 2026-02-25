abstract class RememberRepository {
  Future<List<String>> getRememberedUsers();
  Future<void> saveUser(String username);
  Future<void> deleteUser(String username);

  Future<void> savePassword(String username, String password);
  Future<String?> getPassword(String username);

  Future<void> clearRememberedUsers();
}
