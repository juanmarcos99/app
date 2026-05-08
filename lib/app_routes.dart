import 'package:app/features/diary/ui/pages/add/add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/doctor/doctor.dart';
import 'package:app/features/doctor/ui/pages/PacienteInformation.dart';
import 'package:app/features/doctor/ui/pages/PatientDiary.dart';
import 'package:app/features/doctor/ui/pages/profile_doctor.dart';

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
  static const medicalAppointment = '/medicalAppointment';
  static const qrPage = '/qr';
  static const doctorHomeScreen = '/doctorHome';
  static const scannerPage = '/scanner';
  static const pacienteInformation = '/pacienteInformation';
  static const patientDiary = '/patientDiary';
  static const profileDoctor = '/profileDoctor';

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
      case medicalAppointment:
        return MaterialPageRoute(
          builder: (_) => const MedicalAppointmentPage(),
        );
      case qrPage:
        return MaterialPageRoute(builder: (_) => const QrPage());
      case doctorHomeScreen:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());
      case scannerPage:
        return MaterialPageRoute(builder: (_) => const ScannerPage());
      case pacienteInformation:
        final patient = settings.arguments;
        return MaterialPageRoute(builder: (_) => PacienteInformation(patient: patient));
      case patientDiary:
        final patient = settings.arguments;
        return MaterialPageRoute(builder: (_) => PatientDiaryScreen(patient: patient));
      case profileDoctor:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.instance<ProfileDoctorBloc>(),
            child: const ProfileDoctor(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
        );
    }
  }
}
