import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final String name;
  final String frequency;
  final String nextDose;
  final Color statusColor;
  final String statusText;
  final bool showStock;
  final String? stockMessage;

  const MedicationCard({
    super.key,
    required this.name,
    required this.frequency,
    required this.nextDose,
    required this.statusColor,
    required this.statusText,
    this.showStock = false,
    this.stockMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // (1) Estado
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // (2) Nombre del medicamento
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101519),
            ),
          ),

          const SizedBox(height: 10),

          // (3) Frecuencia
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                "Frecuencia: $frequency",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // (4) Próxima dosis
          Row(
            children: [
              Icon(Icons.event_repeat, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                "Próxima dosis: ",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
              Text(
                nextDose,
                style: const TextStyle(
                  color: Color(0xFF3381C1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // (5) Información adicional opcional (stock)
          if (showStock) ...[
            const SizedBox(height: 6),
            Text(
              stockMessage ?? "",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // (6) Footer con acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.notifications, size: 22, color: Colors.grey),
                  SizedBox(width: 16),
                  Icon(Icons.edit, size: 22, color: Colors.grey),
                  SizedBox(width: 16),
                  Icon(Icons.delete, size: 22, color: Colors.red),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF3381C1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Tomar ahora",
                  style: TextStyle(
                    color: Color(0xFF3381C1),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
