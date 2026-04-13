import 'package:flutter/material.dart';


class LetterNavButton extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;
  final Color? color;
  final double fontSize;

  const LetterNavButton({
    super.key,
    required this.letter,
    required this.onTap,
    this.color,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color ?? theme.colorScheme.primary,
      ),
      child: Text(
        letter,
        style: theme.textTheme.labelLarge!.copyWith(
          fontSize: fontSize,
          color: color ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}
