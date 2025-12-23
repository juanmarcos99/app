import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';

class RegistroEfectDialog extends StatefulWidget {
  final AdverseEvent? initialEvent; // null = registrar, no null = editar

  const RegistroEfectDialog({super.key, this.initialEvent});

  @override
  State<RegistroEfectDialog> createState() => _RegistroEfectDialogState();
}

class _RegistroEfectDialogState extends State<RegistroEfectDialog> {
  final descripcionController = TextEditingController();

  bool get isEditing => widget.initialEvent != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      descripcionController.text = widget.initialEvent?.description ?? '';
    }
  }

  @override
  void dispose() {
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(isEditing ? "Editar evento adverso" : "Registrar evento adverso"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
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

            final ae = AdverseEvent(
              id: widget.initialEvent?.id,
              userId: widget.initialEvent?.userId,
              description: descripcion,
              eventDate: widget.initialEvent?.eventDate,
              registerDate: widget.initialEvent?.registerDate,
            );

            Navigator.pop(context, ae);
          },
          icon: const Icon(Icons.save, color: Colors.white),
          label: Text(
            isEditing ? "Guardar cambios" : "Guardar",
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
