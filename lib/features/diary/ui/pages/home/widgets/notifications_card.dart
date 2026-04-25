import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String text;

  const NotificationCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el esquema de colores y textos del tema actual
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(
          color: cs.surfaceContainerHighest,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.tertiary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.cloud, color: cs.tertiary, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sincronizaciono Pendiente",
                  style: textStyle.bodyMedium?.copyWith(
                    color: cs.onSurface,                    
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: textStyle.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
