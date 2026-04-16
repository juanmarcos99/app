import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomActionButton({
    super.key,
    required this.text,
    this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;


   final Color base = backgroundColor;


    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          vertical: 8,   // antes 14 → ahora compacto
          horizontal: 16, // antes 22 → ahora compacto
        ),
        decoration: BoxDecoration(
          color: base.withValues(alpha:0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: base,
            width: 1.6, // más delgado para botón
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18, // antes 22 → ahora tamaño botón
                color: base,
              ),
            if (icon != null) const SizedBox(width: 6),
            Text(
              text,
              style: textTheme.titleMedium!.copyWith(
                color: base,
                fontWeight: FontWeight.w600,
                fontSize: 14, // más compacto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
