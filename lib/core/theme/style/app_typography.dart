import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  AppTypography._();

  // Titulares grandes
  static const TextStyle headline1Light = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline1Dark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.darkTextPrimary,
  );

  // Titulares medianos
  static const TextStyle headline2Light = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2Dark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.darkTextPrimary,
  );

  // Subtítulos
  static const TextStyle subtitleLight = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle subtitleDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.darkTextSecondary,
  );

  // Texto normal
  static const TextStyle bodyLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkTextPrimary,
  );

  // Texto deshabilitado
  static const TextStyle bodyDisabledLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textDisabled,
  );

  static const TextStyle bodyDisabledDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkTextDisabled,
  );

  // Texto pequeño
  static const TextStyle captionLight = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle captionDark = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  // Botones
  static const TextStyle buttonLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 1.2,
  );

  static const TextStyle buttonDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.darkTextPrimary,
    letterSpacing: 1.2,
  );

  // Campos de formulario
  static const TextStyle inputLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkTextPrimary,
  );

  // Estados (success, error, warning, info)
  static const TextStyle success = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
  );

  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  static const TextStyle warning = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.warning,
  );

  static const TextStyle info = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.info,
  );
}
