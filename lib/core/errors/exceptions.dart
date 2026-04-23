/// Clase base para todas las excepciones de la aplicación
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Errores relacionados con la base de datos local (SQLite)
class LocalDataBaseException extends AppException {
  LocalDataBaseException(super.message);
}

/// Errores relacionados con el servidor o la nube (Supabase)
class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

/// Errores de lógica de negocio o validaciones
class BusinessException extends AppException {
  BusinessException(super.message);
}