import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/features/auth/auth.dart';

abstract class UserRemoteDataSource {
  Future<int> insertUser(UserModel user);
  Future<UserModel?> getUserById(int id);
  Future<UserModel?> authenticateUser(String username, String password);
  Future<UserModel?> getUserByUsername(String username);
  Future<void> updatePassword(String username, String newPasswordHash);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(int id);
  Future<int?> checkUserExistence(String username);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<int> insertUser(UserModel user) async {
    // .select('id').single() asegura que recibamos el ID tras la inserción exitosa
    final response = await supabaseClient
        .from('users')
        .insert(user.toMap())
        .select('id')
        .single();
    return response['id'] as int;
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    final data = await supabaseClient
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? UserModel.fromMap(data) : null;
  }

  @override
  Future<UserModel?> authenticateUser(String username, String password) async {
    // Buscamos coincidencia de usuario y hash de contraseña
    final data = await supabaseClient
        .from('users')
        .select()
        .eq('userName', username)
        .eq('passwordHash', password)
        .maybeSingle();
    return data != null ? UserModel.fromMap(data) : null;
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    final data = await supabaseClient
        .from('users')
        .select()
        .eq('userName', username)
        .maybeSingle();
    return data != null ? UserModel.fromMap(data) : null;
  }

  @override
  Future<void> updatePassword(String username, String newPasswordHash) async {
    await supabaseClient
        .from('users')
        .update({'passwordHash': newPasswordHash})
        .eq('userName', username);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await supabaseClient
        .from('users')
        .update(user.toMap())
        .eq('id', user.id!);
  }

  @override
  Future<void> deleteUser(int id) async {
    await supabaseClient
        .from('users')
        .delete()
        .eq('id', id);
  }

  @override
  Future<int?> checkUserExistence(String username) async {
    // Solo pedimos el ID para minimizar el tráfico de datos
    final data = await supabaseClient
        .from('users')
        .select('id')
        .eq('userName', username)
        .maybeSingle();
    return data != null ? data['id'] as int : null;
  }
}