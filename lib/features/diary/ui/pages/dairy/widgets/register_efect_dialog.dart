import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class RegistroEfectDialog extends StatefulWidget {
  const RegistroEfectDialog({super.key});

  @override
  State<RegistroEfectDialog> createState() => _RegistroEfectDialogState();
}

class _RegistroEfectDialogState extends State<RegistroEfectDialog> {
  final descripcionController = TextEditingController();

  @override
  void dispose() {
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // 👈 fondo blanco
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Registrar crisis"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // más ancho
        height: MediaQuery.of(context).size.height * 0.3, // más alto
        child: TextField(
          controller: descripcionController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Descripción",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final descripcion = descripcionController.text.trim();
            print("Descripción ingresada: $descripcion");
            Navigator.pop(context);
          },
          icon: const Icon(Icons.save, color: Colors.white),
          label: const Text("Guardar", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // 👈 color primario
          ),
        ),
      ],
    );
  }
}
