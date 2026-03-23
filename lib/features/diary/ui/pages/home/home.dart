import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/features/diary/diary.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? userId;

  @override
  void initState() {
    super.initState();

    // Obtener userId desde AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is UserLoggedIn) {
      userId = authState.user.id!;
      context.read<HomeBloc>().add(LoadNotificationsEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Text(
                    "No hay notificaciones disponibles",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Notificaciones",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...state.notifications.map(
                      (msg) => NotificationCard(text: msg),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
