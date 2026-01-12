import 'package:flutter/material.dart';
import 'package:app/features/diary/diary.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mis Medicamentos",
                  style: const TextStyle(
                    color: Color(0xFF101519),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // LISTA
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: const [
                  MedicationCard(
                    statusColor: Colors.green,
                    statusText: "Activo",
                    name: "Paracetamol 500 mg",
                    frequency: "Cada 8 horas",
                    nextDose: "14:00",
                    showStock: false,
                  ),
                ],
              ),
            ),

            // FOOTER BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MedicationFooterButton(onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
