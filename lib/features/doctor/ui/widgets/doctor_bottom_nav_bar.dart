import 'package:flutter/material.dart';
import 'package:app/core/core.dart';

class DoctorBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DoctorBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.primary, 
      unselectedItemColor: AppColors.gray300,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: "Pacientes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: "QR",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}
