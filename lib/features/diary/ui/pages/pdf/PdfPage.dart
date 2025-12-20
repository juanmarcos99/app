import 'package:flutter/material.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Pantalla de PDF",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
