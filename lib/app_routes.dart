import 'package:flutter/material.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';


class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const diary = '/diary';
  static const home = '/home';
  static const mainNavigationPage = '/mainNavigation';
  static const medication = '/medication';
  static const settingsPage = '/settings';
  static const addPage = '/add';
  static const pdf = '/pdf';
  static const changePassword = '/changePassword';
  static const profileData = '/profileData';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterUserPage());
      case diary:
        return MaterialPageRoute(builder: (_) => const DiaryPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case mainNavigationPage:
        return MaterialPageRoute(builder: (_) => const MainNavigationPage());
      case medication:
        return MaterialPageRoute(builder: (_) => const MedicationPage());
      case settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case addPage:
        return MaterialPageRoute(builder: (_) => const AddPage());
      case pdf:
        return MaterialPageRoute(builder: (_) => const ExportPdfPage());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
         case profileData:
        return MaterialPageRoute(builder: (_) => const ProfileDataPage());    
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
        );
    }
  }
}
