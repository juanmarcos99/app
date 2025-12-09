import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 73, 112, 144)),
        enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
        ),
        
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 28, 153, 255), width: 2),
        ),
        
        border: const UnderlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 253, 250, 250),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 28, 153, 255)),
      ),
    );
  }
}
