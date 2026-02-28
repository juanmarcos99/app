import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class AppSnack {
  static void show(
    BuildContext context,
    String message, {
    Color? color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.captionDark,
        ),
        backgroundColor: color ?? AppColors.primary,
      ),
    );
  }
}
