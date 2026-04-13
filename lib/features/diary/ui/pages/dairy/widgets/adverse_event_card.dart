import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary.dart'; // Mantén tus imports originales

class AdverseEventCard extends StatelessWidget {
  final AdverseEvent adverseEvent;

  const AdverseEventCard({super.key, required this.adverseEvent});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono principal
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.medical_services,
              color: cs.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // Contenido central (Expandido para ocupar el espacio restante)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adverseEvent.description ?? "Evento adverso",
                  style: text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Fecha del evento
                _buildInfoRow(
                  context, 
                  icon: Icons.event, 
                  label: "Fecha: ${_formatDate(adverseEvent.eventDate)}"
                ),
                
                const SizedBox(height: 4),
                
                // Fecha de registro
                _buildInfoRow(
                  context, 
                  icon: Icons.edit_calendar, 
                  label: "Registrado: ${_formatDate(adverseEvent.registerDate)}"
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Botones de acción en columna para evitar overflow horizontal
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _ActionButton(
                icon: Icons.edit,
                color: cs.primary,
                onTap: () => _showEditDialog(context),
              ),
              const SizedBox(height: 8),
              _ActionButton(
                icon: Icons.delete,
                color: cs.error,
                onTap: () => _showDeleteDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para las filas de información (Fecha/Registro)
  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label}) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded( // Esto evita que el texto largo de la fecha desborde
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: cs.onSurfaceVariant,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Lógica de Diálogos extraída para limpiar el build
  Future<void> _showEditDialog(BuildContext context) async {
    final result = await showDialog<AdverseEvent>(
      context: context,
      useRootNavigator: false,
      builder: (_) => RegistroEfectDialog(initialEvent: adverseEvent),
    );

    if (result != null && context.mounted) {
      context.read<DiaryBloc>().add(UpdateAdverseEventEvent(result));
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar evento"),
        content: const Text("¿Estás seguro de que deseas eliminar este evento adverso?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Eliminar", style: TextStyle(color: cs.error)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true && adverseEvent.id != null && context.mounted) {
      context.read<DiaryBloc>().add(DeleteAdverseEventEvent(adverseEvent.id!));
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.year}-${_two(date.month)}-${_two(date.day)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

// Botón de acción pequeño y estilizado
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}