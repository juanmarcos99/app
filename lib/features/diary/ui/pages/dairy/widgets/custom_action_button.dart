import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

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
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, color:  AppColors.white),
      label: Text(text, style: const TextStyle(color:  AppColors.white)),
      onPressed: onPressed,
    );
  }
}
