import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  /// Genera un hash SHA-256 de la contraseña.
  static String hash(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifica si la contraseña ingresada coincide con el hash almacenado.
  static bool verify(String password, String storedHash) {
    return hash(password) == storedHash;
  }
}
