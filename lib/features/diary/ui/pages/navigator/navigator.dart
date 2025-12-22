import 'package:app/core/theme/style/colors.dart';
import 'package:flutter/material.dart';
import '../../../diary.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _index = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const DiaryPage(),    
    const AddPage(),
    const PdfPage(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    "Home",
    "Diario",
    "Agregar",
    "PDF",
    "Ajustes",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(_titles[_index], style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
