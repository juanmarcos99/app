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
    const SizedBox.shrink(),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          _titles[_index],
          style: theme.textTheme.titleMedium?.copyWith(
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Guardamos las referencias a los Blocs antes de entrar en procesos asíncronos
    final authBloc = context.read<AuthBloc>();
    final diaryBloc = context.read<DiaryBloc>();
    final medicationBloc = context.read<MedicationBloc>();

    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _MenuActionTile(
                          icon: Icons.warning_amber_rounded,
                          text: "Crisis",
                          color: Colors.orange,
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await showDialog<Crisis>(
                              context: context,
                              useRootNavigator: false,
                              builder: (_) => const RegisterCrisisDialog(),
                            );
                            
                            if (result != null && mounted) {
                              final authState = authBloc.state;
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
                              diaryBloc.add(AddCrisisEvent(crisis));
                              diaryBloc.add(LoadCalendarEvent(userId));
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _MenuActionTile(
                          icon: Icons.sick,
                          text: "Evento Adverso",
                          color: cs.error,
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await showDialog<AdverseEvent>(
                              context: context,
                              useRootNavigator: false,
                              builder: (_) => const RegistroEfectDialog(),
                            );
                            
                            if (result != null && mounted) {
                              final authState = authBloc.state;
                              if (authState is! UserLoggedIn) return;
                              final userId = authState.user.id!;
                              final efecto = AdverseEvent(
                                registerDate: DateTime.now(),
                                eventDate: DateTime.now(),
                                description: result.description,
                                userId: userId,
                              );
                              diaryBloc.add(AddAdverseEventEvent(efecto));
                              diaryBloc.add(LoadCalendarEvent(userId));
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _MenuActionTile(
                          icon: Icons.medication,
                          text: "Medicamento",
                          color: cs.primary,
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await showDialog<(Medication, bool)>(
                              context: context,
                              useRootNavigator: false,
                              builder: (_) => const RegisterMedicationDialog(),
                            );
                            
                            if (result != null && mounted) {
                              final authState = authBloc.state;
                              if (authState is! UserLoggedIn) return;
                              final userId = authState.user.id!;
                              final (medication, shouldSchedule) = result;
                              final medWithUser = medication.copyWith(userId: userId);
                              medicationBloc.add(
                                AddMedicationEvent(medWithUser, shouldSchedule),
                              );
                            }
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
}

class _MenuActionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _MenuActionTile({
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Icon(Icons.add_circle_outline, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}