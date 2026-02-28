import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;

  const ConfirmationDialog({
    super.key,
    this.title = "Confirmación",
    this.message = "¿Estás seguro de realizar esta acción?",
    this.cancelText = "Cancelar",
    this.confirmText = "Aceptar",
    this.confirmColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: Text(cancelText),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
          ),
          child: Text(
            confirmText,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
