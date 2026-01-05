import 'package:app/core/injection/injection.dart';
import 'package:app/features/diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await initCoreDependencies();
  initAuthDependencies();
  initDiaryDependencies();
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
      ],
      child: MaterialApp(
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
        },
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
