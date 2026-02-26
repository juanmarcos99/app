import 'package:app/core/core_injection.dart';
import 'package:app/features/diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

/// Punto de entrada principal de la aplicación
Future<void> main() async {
  // Inicializa los bindings de Flutter antes de cualquier configuración
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquea la orientación de la aplicación en modo vertical (portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Inicializa la configuración regional para fechas en español
  await initializeDateFormatting('es_ES', null);

  // Inyección de dependencias del núcleo
  await initCoreDependencies();

  // Inyección de dependencias específicas de cada feature
  initAuthDependencies();
  initDiaryDependencies();

 /*  // Solicita permisos de notificaciones en runtime (Android 13+)
  final notificationService = NotificationService();
  await notificationService.requestNotificationPermission(); */

  // Ejecuta la aplicación principal
  runApp(const MainApp());
}

/// Widget raíz de la aplicación
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Proveedores de BLoCs para manejar el estado de cada feature
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<AuthBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<DiaryBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<ReportBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<MedicationBloc>()),
      ],
      child: MaterialApp(
        // Ruta inicial de la aplicación
        initialRoute: AppRoutes.login,

        // Definición de rutas de navegación
        routes: {
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.register: (context) => const RegisterUserPage(),
          AppRoutes.diary: (context) => const DiaryPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.mainNavigationPage: (context) => const MainNavigationPage(),
          AppRoutes.medication: (context) => const MedicationPage(),
          AppRoutes.settingsPage: (context) => const SettingsPage(),
          AppRoutes.addPage: (context) => const AddPage(),
          AppRoutes.pdf: (context) => const ExportPdfPage(),
          AppRoutes.changePassword: (context) => const ChangePasswordScreen(),
        },

        // Configuración de localización e internacionalización
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES')],
      ),
    );
  }
}
