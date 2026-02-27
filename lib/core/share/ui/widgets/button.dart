import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
          elevation: 0,
        ),
        child: Text(
          text.toUpperCase(),
          style: isDark ? AppTypography.buttonDark : AppTypography.buttonLight,
        ),
      ),
    );
  }
}
