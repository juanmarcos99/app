import 'package:app/features/diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:app/core/core.dart'; 


class RegisterCrisisDialog extends StatefulWidget {
  final Crisis? initialCrisis;

  const RegisterCrisisDialog({super.key, this.initialCrisis});

  @override
  State<RegisterCrisisDialog> createState() => _RegisterCrisisDialogState();
}

class _RegisterCrisisDialogState extends State<RegisterCrisisDialog> {
  late DateTime fecha;
  String? horario;
  String? tipoSeleccionado;

  final _formKey = GlobalKey<FormState>();

  final List<String> horarios = [
    '6:00 am - 10:00 am',
    '10:00 am - 2:00 pm',
    '2:00 pm - 6:00 pm',
    '6:00 pm - 10:00 pm',
    '10:00 pm - 6:00 am',
  ];

  final List<String> tiposCrisis = [
    'Focales conscientes',
    'Focales inconscientes',
    'Tónico-clónico bilateral',
    'Añadir otro tipo',
  ];

  final cantidadController = TextEditingController();
  final descripcionController = TextEditingController();

  bool get isEditing => widget.initialCrisis != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final crisis = widget.initialCrisis!;
      fecha = crisis.crisisDate ?? DateTime.now();
      horario = horarios.contains(crisis.timeRange) ? crisis.timeRange : null;
      tipoSeleccionado = tiposCrisis.contains(crisis.type)
          ? crisis.type
          : 'Añadir otro tipo';

      if (tipoSeleccionado == 'Añadir otro tipo') {
        descripcionController.text = crisis.type ?? '';
      }
      cantidadController.text = crisis.quantity?.toString() ?? '';
    } else {
      fecha = DateTime.now();
      horario = null;
      tipoSeleccionado = null;
    }
  }

  @override
  void dispose() {
    cantidadController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final tipoFinal = tipoSeleccionado == 'Añadir otro tipo'
        ? descripcionController.text.trim()
        : tipoSeleccionado ?? '';

    final crisis = Crisis(
      id: widget.initialCrisis?.id,
      registeredDate: widget.initialCrisis?.registeredDate,
      crisisDate: fecha,
      timeRange: horario ?? '',
      quantity: int.tryParse(cantidadController.text.trim()) ?? 0,
      type: tipoFinal,
      userId: widget.initialCrisis?.userId,
    );

    Navigator.pop(context, crisis);
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
        isEditing ? "Editar Crisis" : "Registro de Crisis",
        style: text.displayMedium?.copyWith(fontSize: 22),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          // Evita que el teclado tape los campos
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // El diálogo se ajusta al contenido
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Horario del episodio", text, cs),
                DropdownButtonFormField<String>(
                  value: horario,
                  dropdownColor: cs.surface,
                  style: text.bodyLarge,
                  items: horarios
                      .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                      .toList(),
                  onChanged: (value) => setState(() => horario = value),
                  decoration: _inputDecoration(cs, "Seleccione horario"),
                  validator: (value) => value == null ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                
                _buildLabel("Tipo de crisis", text, cs),
                DropdownButtonFormField<String>(
                  value: tipoSeleccionado,
                  dropdownColor: cs.surface,
                  style: text.bodyLarge,
                  items: tiposCrisis
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (value) => setState(() => tipoSeleccionado = value),
                  decoration: _inputDecoration(cs, "Seleccione tipo"),
                  validator: (value) => value == null ? 'Campo requerido' : null,
                ),
                
                const SizedBox(height: 16),

                // Campos condicionales con animación simple o espaciado controlado
                if (tipoSeleccionado != null) ...[
                  if (tipoSeleccionado == 'Añadir otro tipo') ...[
                    _buildLabel("Descripción personalizada", text, cs),
                    TextFormField(
                      controller: descripcionController,
                      style: text.bodyLarge,
                      decoration: _inputDecoration(cs, "Ej. Crisis focal..."),
                      validator: (value) => value!.isEmpty ? 'Ingrese descripción' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  _buildLabel("Cantidad de episodios", text, cs),
                  TextFormField(
                    controller: cantidadController,
                    keyboardType: TextInputType.number,
                    style: text.bodyLarge,
                    decoration: _inputDecoration(cs, "Número de crisis"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingrese cantidad';
                      final n = int.tryParse(value);
                      return (n == null || n <= 0) ? 'Número inválido' : null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: TextStyle(color: cs.onSurfaceVariant)),
        ),
        ElevatedButton.icon(
          onPressed: _onSave,
          icon: const Icon(Icons.save_rounded, size: 18),
          label: Text(isEditing ? "Guardar" : "Registrar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para etiquetas de campos
  Widget _buildLabel(String label, TextTheme text, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: text.titleMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: cs.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }

  // Estilo de los inputs basado en el Theme
  InputDecoration _inputDecoration(ColorScheme cs, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: cs.surfaceContainerHighest.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      errorStyle: const TextStyle(fontSize: 12),
    );
  }
}