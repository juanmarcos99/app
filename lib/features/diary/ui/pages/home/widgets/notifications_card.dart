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
      // Alineamos los márgenes a los de CrisisCard (12 horizontal, 8 vertical)
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface, // Mismo fondo que CrisisCard
        borderRadius: BorderRadius.circular(16), // Mismo radio
        border: Border.all(
          color: cs.surfaceContainerHighest, // Mismo color de borde
          width: 1.0, 
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenedor de icono estilo "Premium" (igual al de CrisisCard)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha:0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: cs.primary,
              size: 26, // Ajustado para equilibrio visual
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: textStyle.bodyLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
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