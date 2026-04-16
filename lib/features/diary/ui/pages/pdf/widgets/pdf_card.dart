import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class PdfCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onOpen;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const PdfCard({
    super.key,
    required this.fileName,
    required this.onOpen,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Cambia según el brillo del tema
        color: theme.brightness == Brightness.light 
            ? AppColors.white 
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:theme.brightness == Brightness.light ? 0.05 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono con contenedor tonal para seguir el estilo Bento
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.picture_as_pdf, color: colorScheme.error, size: 28),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Documento PDF",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            color: theme.brightness == Brightness.light ? Colors.white : colorScheme.surface,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
            onSelected: (value) {
              if (value == 'abrir') onOpen();
              if (value == 'compartir') onShare();
              if (value == 'borrar') onDelete();
            },
            itemBuilder: (context) => [
              _buildMenuItem('abrir', Icons.open_in_new, "Abrir", colorScheme.primary),
              _buildMenuItem('compartir', Icons.share, "Compartir", colorScheme.primary),
              _buildMenuItem('borrar', Icons.delete, "Borrar", colorScheme.error),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}