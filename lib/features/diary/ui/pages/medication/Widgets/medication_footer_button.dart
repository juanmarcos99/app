import 'package:app/core/core.dart';
import 'package:flutter/material.dart';

class MedicationFooterButton extends StatelessWidget {
  final VoidCallback onTap;

  const MedicationFooterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(
        Icons.history,
        size: 18,
        color: AppColors.primary,
      ),
      label: const Text(
        "Ver historial de tomas",
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
