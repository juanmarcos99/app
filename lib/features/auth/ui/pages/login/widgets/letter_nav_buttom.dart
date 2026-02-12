import 'package:flutter/material.dart';
import 'package:app/core/core.dart';


class LetterNavButton extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;
  final Color color;
  final double fontSize;

  const LetterNavButton({
    super.key,
    required this.letter,
    required this.onTap,
    this.color = AppColors.primary,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textStyle = isDark
        ? AppTypography.subtitleDark.copyWith(
            fontSize: fontSize,
            color: color,
          )
        : AppTypography.subtitleLight.copyWith(
            fontSize: fontSize,
            color: color,
          );

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
      ),
      child: Text(letter, style: textStyle),
    );
  }
}
