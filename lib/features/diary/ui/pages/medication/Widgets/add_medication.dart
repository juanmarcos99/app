import 'package:flutter/material.dart';
import 'package:app/core/core.dart'; 

class AddMedicationDialog extends StatefulWidget {
  const AddMedicationDialog({super.key});

  @override
  State<AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<AddMedicationDialog> {
  List<TimeOfDay> times = []; // inicialmente vacío
  bool remindersEnabled = false; // estado del recordatorio

  Future<void> pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: times[index],
      initialEntryMode: TimePickerEntryMode.input, // siempre digital
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: AppColors.secundary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => times[index] = picked);
    }
  }

  Future<void> addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() => times.add(picked));
    }
  }

  String formatTime(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.calendarActualDay,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              "Registro Detallado",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secundary,
              ),
            ),
            const SizedBox(height: 16),

            _InputSection(label: "Nombre del medicamento", hint: "Ej. Ibuprofeno"),
            _InputSection(label: "Dosis", hint: "Ej. 600mg"),

            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                "Horario de toma",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secundary,
                ),
              ),
            ),

            // Lista de horarios
            Column(
              children: [
                for (int i = 0; i < times.length; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatTime(times[i]),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secundary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.primary),
                          onPressed: () => pickTime(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.orange),
                          onPressed: () => setState(() => times.removeAt(i)),
                        ),
                      ],
                    ),
                  ),

                TextButton.icon(
                  onPressed: addTime,
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                  label: const Text(
                    "Añadir horario",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // Recordatorio
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "¿Desea recibir recordatorios?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secundary,
                      ),
                    ),
                  ),
                  Switch(
                    value: remindersEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => remindersEnabled = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Guardar medicamento",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputSection extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;

  const _InputSection({required this.label, required this.hint, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.secundary)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.grey),
              ),
              suffixIcon: icon != null ? Icon(icon, color: AppColors.grey) : null,
            ),
          ),
        ],
      ),
    );
  }
}
