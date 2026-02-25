import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Almacenamiento seguro para datos sensibles
  final FlutterSecureStorage secure = const FlutterSecureStorage();

  
  //--------------------- MÉTODOS PARA DATOS NORMALES---------------------------
  

  // Guardar String
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Leer String
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Guardar bool
  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Leer bool
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Guardar int
  Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Leer int
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Guardar lista de Strings
  Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  // Leer lista de Strings
  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  
  // -------------------MÉTODOS PARA JSON--------------------
  

  // Guardar JSON como String
  Future<void> saveJson(String key, Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  // Leer JSON
  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  
  //---------------- MÉTODOS PARA DATOS SENSIBLES-----------------
  

  // Guardar dato seguro
  Future<void> saveSecure(String key, String value) async {
    await secure.write(key: key, value: value);
  }

  // Leer dato seguro
  Future<String?> getSecure(String key) async {
    return await secure.read(key: key);
  }

  // Borrar dato seguro
  Future<void> deleteSecure(String key) async {
    await secure.delete(key: key);
  }

  
  // Borrar SharedPreferences y SecureStorage
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await secure.deleteAll();
  }
}
