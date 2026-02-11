import 'package:flutter/material.dart';
import 'package:app/core/theme/style/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<String> get reminderMessages => const [
    "Aún no has registrado tus crisis esta semana.",
    "Revisa si hubo eventos adversos recientes que debas anotar.",
    "Mantener el diario actualizado ayuda a detectar patrones.",
    "Si tuviste síntomas hoy, recuerda registrarlos.",
    "Hace varios días que no actualizas tu diario.",
    "Un registro consistente facilita el seguimiento clínico.",
    "Verifica si necesitas completar datos pendientes de esta semana.",
  ];

  @override
  Widget build(BuildContext context) {
    final selectedMessages = reminderMessages.toList()..shuffle();
    final messagesToShow = selectedMessages.take(3).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Recordatorios",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...messagesToShow.map((msg) => ReminderBubble(message: msg)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ReminderBubble extends StatelessWidget {
  final String message;

  const ReminderBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha:0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha:0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
