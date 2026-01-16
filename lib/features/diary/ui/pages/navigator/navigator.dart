import 'package:app/core/theme/style/colors.dart';
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
    const AddPage(),
    const MedicationPage(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    "Home",
    "Diario",
    "Agregar",
    "Medicacíon",
    "Ajustes",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          _titles[_index],
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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

  // -------------------------------------------------------------
  // 🔥 Menú flotante bonito, compacto y con botones del mismo tamaño
  // -------------------------------------------------------------
  void _showAddMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 85),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🔥 Tamaño fijo para todos los botones
                        SizedBox(
                          width: 220,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Agregar crisis",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              final result = await showDialog<Crisis>(
                                context: context,
                                useRootNavigator: false,
                                builder: (_) => const RegisterCrisisDialog(),
                              );

                              if (result != null) {
                                final authState = context
                                    .read<AuthBloc>()
                                    .state;
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

                                context.read<DiaryBloc>().add(
                                  AddCrisisEvent(crisis),
                                );
                                context.read<DiaryBloc>().add(
                                  LoadCalendarEvent(userId),
                                );
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: 220,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.health_and_safety,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Agregar evento adverso",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // sin lógica por ahora
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: 220,
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.medication,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Agregar medicamento",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // sin lógica por ahora
                            },
                          ),
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
}
