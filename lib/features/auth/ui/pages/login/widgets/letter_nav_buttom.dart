import 'package:flutter/material.dart';

class LetterNavButton extends StatelessWidget {
  final String letter;          //  la letra o palabra que muestra
  final VoidCallback onTap;     //  acción al tocar
  final Color color;            //  color del texto
  final double fontSize;        //  tamaño de la letra

  const LetterNavButton({
    super.key,
    required this.letter,
    required this.onTap,
    this.color = Colors.blue,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        letter,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
