import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // 🔥 permite más de 3 ítems
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue, // 🎨 color seleccionado
      unselectedItemColor: Colors.grey, // 🎨 color no seleccionado
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Calendario",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: "Agregar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: "PDF",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Ajustes",
        ),
      ],
    );
  }
}

