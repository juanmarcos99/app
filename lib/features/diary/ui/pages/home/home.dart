import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/main.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      userId = authState.user.id!;
      context.read<HomeBloc>().add(LoadNotificationsEvent(userId!));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return BlocListener<DiaryBloc, DiaryState>(
      listener: (context, state) {
        if (state is CrisisAdded ||
            state is CrisisUpdated ||
            state is CrisisDeleted ||
            state is MedicationAdded ||
            state is MedicationDeleted ||
            state is MedicationLoaded) {
          _loadNotifications();
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface, // Dinámico según el tema
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: cs.primary,
                    strokeWidth: 3,
                  ),
                );
              }

              if (state is HomeLoaded) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none_rounded, 
                             size: 64, color: cs.onSurfaceVariant.withValues(alpha:0.4)),
                        const SizedBox(height: 16),
                        Text(
                          "No hay notificaciones disponibles",
                          style: text.bodyLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Notificaciones:",
                          style: text.displayMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Lista de notificaciones
                      ...state.notifications.map(
                        (msg) => NotificationCard(text: msg),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              }

              if (state is HomeError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(color: cs.error),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}