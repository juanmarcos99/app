import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Colores de marca
  static const Color primary = Color.fromARGB(255, 51, 128, 192);
  static const Color primaryLight = Color.fromARGB(255, 202, 241, 255);
  static const Color secondary = Color.fromARGB(255, 28, 68, 146);

  // Texto modo claro
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // Texto modo oscuro
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextDisabled = Color(0xFF6B7280);

  // Neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color.fromARGB(255, 192, 192, 192);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Fondos modo claro
  static const Color background = Color(0xFFF3F4F6);
  static const Color backgroundAlt = Color(0xFFE5E7EB);

  // Superficies modo claro
  static const Color surface = white;
  static const Color surfaceSoft = Color.fromARGB(255, 246, 246, 246);
  static const Color surfaceSelected = Color.fromARGB(255, 241, 241, 241);

  // Fondos modo oscuro
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkBackgroundAlt = Color(0xFF111827);

  // Superficies modo oscuro
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceSoft = Color(0xFF1E242C);
  static const Color darkSurfaceSelected = Color(0xFF2A313C);

  // Estados y feedback
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFDC2626);
  static const Color errorSoft = Color(0xFFFEE2E2);
  static const Color warning = Color.fromARGB(255, 255, 152, 0);
  static const Color warningSoft = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF0284C7);
  static const Color infoSoft = Color(0xFFE0F2FE);

  // Acentos
  static const Color orange = Color.fromARGB(255, 255, 152, 0);

  // Overlays
  static const Color overlaySoft = Color(0x66000000);
  static const Color overlayStrong = Color(0x99000000);

  // Gradientes
  static const List<Color> primaryGradient = [primary, secondary];
  static const List<Color> blueSoftGradient = [primaryLight, primary];
}
