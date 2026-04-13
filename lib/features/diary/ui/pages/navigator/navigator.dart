import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../diary.dart';
import 'package:app/features/auth/auth.dart';

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
    const AddPage(), // Este se intercepta en el onTap
    const MedicationPage(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    "Home",
    "Diario",
    "Agregar",
    "Medicación",
    "Ajustes",
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          _titles[_index],
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: IndexedStack(index: _index, children: _screens),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _index,
        onTap: (i) {
          if (i == 2) {
            _showAddMenu(context);
          } else {
            setState(() => _index = i);
          }
        },
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black54, // Un poco más oscuro para dar foco al menú
      builder: (context) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100), // Ajustado para que no tape la barra
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(24),
                      // BORDE DINÁMICO SEGÚN EL TEMA
                      border: Border.all(
                        color: isDark 
                            ? Colors.white.withOpacity(0.12) 
                            : Colors.black.withOpacity(0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuButton(
                          context,
                          icon: Icons.warning_amber_rounded,
                          label: "Agregar crisis",
                          onTap: () async {
                            Navigator.pop(context); // Cerrar menú antes de abrir diálogo
                            final result = await showDialog<Crisis>(
                              context: context,
                              useRootNavigator: false,
                              builder: (_) => const RegisterCrisisDialog(),
                            );
                            if (result != null) _handleCrisisAdd(context, result);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuButton(
                          context,
                          icon: Icons.health_and_safety_outlined,
                          label: "Agregar evento adverso",
                          onTap: () async {
                            Navigator.pop(context);
                            final result = await showDialog<AdverseEvent>(
                              context: context,
                              useRootNavigator: false,
                              builder: (_) => const RegistroEfectDialog(),
                            );
                            if (result != null) _handleAdverseEventAdd(context, result);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuButton(
                          context,
                          icon: Icons.medication_outlined,
                          label: "Agregar medicamento",
                          onTap: () async {
                            Navigator.pop(context);
                            final result = await showDialog<(Medication, bool)>(
                              context: context,
                              useRootNavigator: false,
                              builder: (_) => const RegisterMedicationDialog(),
                            );
                            if (result != null) _handleMedicationAdd(context, result);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget auxiliar para mantener el menú limpio y responsivo al tema
  Widget _buildMenuButton(BuildContext context, {
    required IconData icon, 
    required String label, 
    required VoidCallback onTap
  }) {
    final cs = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: 240,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: cs.onPrimary, size: 20),
        label: Text(
          label,
          style: TextStyle(color: cs.onPrimary, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }

  // --- MÉTODOS DE AYUDA PARA MANTENER EL CÓDIGO LIMPIO ---

  void _handleCrisisAdd(BuildContext context, Crisis result) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! UserLoggedIn) return;
    final userId = authState.user.id!;
    
    final crisis = CrisisModel(
      registeredDate: DateTime.now(),
      crisisDate: DateTime.now(),
      timeRange: result.timeRange,
      quantity: result.quantity,
      type: result.type,
      userId: userId,
    );

    context.read<DiaryBloc>().add(AddCrisisEvent(crisis));
    context.read<DiaryBloc>().add(LoadCalendarEvent(userId));
  }

  void _handleAdverseEventAdd(BuildContext context, AdverseEvent result) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! UserLoggedIn) return;
    final userId = authState.user.id!;

    final efecto = AdverseEvent(
      registerDate: DateTime.now(),
      eventDate: DateTime.now(),
      description: result.description,
      userId: userId,
    );

    context.read<DiaryBloc>().add(AddAdverseEventEvent(efecto));
    context.read<DiaryBloc>().add(LoadCalendarEvent(userId));
  }

  void _handleMedicationAdd(BuildContext context, (Medication, bool) result) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! UserLoggedIn) return;
    
    final (medication, shouldSchedule) = result;
    final medWithUser = medication.copyWith(userId: authState.user.id!);

    context.read<MedicationBloc>().add(
      AddMedicationEvent(medWithUser, shouldSchedule),
    );
  }
}