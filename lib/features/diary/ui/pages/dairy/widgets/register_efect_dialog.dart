import 'package:flutter/material.dart';
import '../../../../diary.dart'; 
import 'package:app/core/core.dart'; 

class RegistroEfectDialog extends StatefulWidget {
  final AdverseEvent? initialEvent;

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
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        isEditing ? "Editar evento adverso" : "Registrar evento adverso",
        style: text.displayMedium?.copyWith(fontSize: 20),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          // Esto evita el overflow cuando el teclado sube
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  "Descripción del evento",
                  style: text.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              TextField(
                controller: descripcionController,
                maxLines: 5,
                style: text.bodyLarge,
                decoration: InputDecoration(
                  hintText: "Escribe aquí lo ocurrido...",
                  filled: true,
                  fillColor: cs.surfaceContainerHighest.withOpacity(0.3),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.outline.withOpacity(0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancelar",
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final descripcion = descripcionController.text.trim();
            final ae = AdverseEvent(
              id: widget.initialEvent?.id,
              userId: widget.initialEvent?.userId,
              description: descripcion,
              eventDate: widget.initialEvent?.eventDate ?? DateTime.now(),
              registerDate: widget.initialEvent?.registerDate ?? DateTime.now(),
            );
            Navigator.pop(context, ae);
          },
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: Text(isEditing ? "Guardar cambios" : "Registrar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor:AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}