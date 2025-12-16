import 'package:app/features/diary/ui/pages/dairy/dairy_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/ui/auth_ui.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const diary = '/diary';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterUserPage());
      case diary:
        return MaterialPageRoute(builder: (_) => const DiaryPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
        );
    }
  }
}
