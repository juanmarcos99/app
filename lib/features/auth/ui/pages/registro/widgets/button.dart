import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 0, 121, 220), // 👈 azul oscuro por defecto
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, //ancho completo
      height: 50, // altura generosa
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45), // 👈 esquinas redondeadas
          ),
        ),
        child: Text(
          text.toUpperCase(), // 👈 texto en mayúsculas
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
