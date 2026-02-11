import 'dart:developer' as developer;

class Logger {
  Logger._();

  static void d(String message, {String name = 'APP'}) {
    developer.log(message, name: name, level: 500);
  }

  static void i(String message, {String name = 'APP'}) {
    developer.log(message, name: name, level: 800);
  }

  static void w(String message, {Object? error, StackTrace? stack, String name = 'APP'}) {
    developer.log(message, name: name, level: 900, error: error, stackTrace: stack);
  }

  static void e(String message, {Object? error, StackTrace? stack, String name = 'APP'}) {
    developer.log(message, name: name, level: 1000, error: error, stackTrace: stack);
  }
}
