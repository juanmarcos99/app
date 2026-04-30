import 'package:app/features/diary/diary.dart';
import 'package:app/features/diary/ui/pages/add/add_page.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:app/core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/features/doctor/doctor.dart';
import 'package:app/features/doctor/doctor_injection.dart';

// RouteObserver global para detectar navegación
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

try {
    debugPrint('Intentando conectar con Supabase...');
    
    await Supabase.initialize(
      url: 'https://ggxgvbfzwrpctguazpqz.supabase.co', 
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdneGd2YmZ6d3JwY3RndWF6cHF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4Nzc5MTAsImV4cCI6MjA5MjQ1MzkxMH0.j9YRkn1erZPyUZHcNVbaioiYTBSWWGcEC6Bko8zdCLI', 
    );
    
    debugPrint('✅ Supabase inicializado correctamente');
  } catch (e) {
    // Si falla, el error aparecerá aquí en lugar de congelar la app
    debugPrint('❌ Error al inicializar Supabase: $e');
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeDateFormatting('es_ES', null);

  await initCoreDependencies();
  initAuthDependencies();
  initDiaryDependencies();
  initDoctorDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<AuthBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<DiaryBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<ReportBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<MedicationBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<ProfileBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<AppointmentBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<HomeBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<DoctorBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<ScanPatientBloc>()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme, // Tema claro
        darkTheme: AppTheme.darkTheme, // Tema oscuro
        themeMode: ThemeMode.system, // Cambia automáticamente según el teléfono

        initialRoute: AppRoutes.login,
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
          AppRoutes.profileData: (context) => const ProfileDataPage(),
          AppRoutes.medicalAppointment: (context) =>
              const MedicalAppointmentPage(),
          AppRoutes.qrPage: (context) => const QrPage(),
          AppRoutes.doctorHomeScreen: (context) => const DoctorHomeScreen(),
          AppRoutes.scannerPage: (context) => const ScannerPage(),
          AppRoutes.pacienteInformation: (context) => const PacienteInformation(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES')],
        //  Aquí conectamos el RouteObserver
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
//Contraseña de la base de datos de supabase BdzPKgGLOMTpsz2H
