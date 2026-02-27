import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class CustomOptionButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomOptionButton({
    super.key,
    this.icon,
    this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppColors.primary;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, color: effectiveColor, size: 22),

          if (icon != null && text != null)
            const SizedBox(width: 8),

          if (text != null)
            Text(
              text!,
              style: AppTypography.bodyLight.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}