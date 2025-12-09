import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;                // valor de este radio
  final T groupValue;           // valor seleccionado en el grupo
  final ValueChanged<T?> onChanged; // callback al seleccionar
  final String label;           // texto que acompaña al radio
  final Color color;            // propiedad para elegir el color

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.color = Colors.blue,   //color por defecto azul
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          // ignore: deprecated_member_use
          groupValue: groupValue,
          // ignore: deprecated_member_use
          onChanged: onChanged,
          activeColor: color, // aquí aplicamos el color
        ),
        Text(
          label,
          style: TextStyle(color: color), //texto también con ese color
        ),
      ],
    );
  }
}
