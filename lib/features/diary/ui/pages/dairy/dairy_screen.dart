import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/style/colors.dart';
import 'package:app/features/auth/auth.dart';
import '../../../diary.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is UserLoggedIn) {
        final userId = authState.user.id!;
        final diaryBloc = context.read<DiaryBloc>();

        diaryBloc.add(
          LoadTarjetasEvent(userId: userId, date: diaryBloc.daySelected),
        );

        diaryBloc.add(LoadCalendarEvent(userId));
      }
    });
  }

  void _reloadTarjetas() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! UserLoggedIn) return;

    final userId = authState.user.id!;
    context.read<DiaryBloc>().add(
      LoadTarjetasEvent(userId: userId, date: context.read<DiaryBloc>().daySelected),
    );
  }

  void _reloadCalendar() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! UserLoggedIn) return;

    final userId = authState.user.id!;
    context.read<DiaryBloc>().add(LoadCalendarEvent(userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryBloc, DiaryState>(
      listener: (context, state) {
        if (state is CrisisAdded ||
            state is CrisisUpdated ||
            state is CrisisDeleted ||
            state is AdverseEventAdded ||
            state is AdverseEventUpdated ||
            state is AdverseEventDeleted) {
          _reloadTarjetas();
          _reloadCalendar();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Calendario con altura controlada
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 320,
                      maxHeight: constraints.maxHeight * 0.55,
                    ),
                    child: const DiaryCalendar(),
                  );
                },
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildActionButtons(context),
              ),

              const SizedBox(height: 12),

              // Scroll SOLO para las tarjetas
              Expanded(
                child: _buildScrollableContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;

        if (isNarrow) {
          return Column(
            children: [
              CustomActionButton(
                text: "Añadir crisis",
                icon: Icons.add,
                backgroundColor: AppColors.primary,
                onPressed: () => _handleAddCrisis(context),
              ),
              const SizedBox(height: 8),
              CustomActionButton(
                text: "Añadir Efecto",
                icon: Icons.add,
                backgroundColor: AppColors.secundary,
                onPressed: () => _handleAddAdverseEvent(context),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: CustomActionButton(
                text: "Añadir crisis",
                icon: Icons.add,
                backgroundColor: AppColors.primary,
                onPressed: () => _handleAddCrisis(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomActionButton(
                text: "Añadir Efecto",
                icon: Icons.add,
                backgroundColor: AppColors.secundary,
                onPressed: () => _handleAddAdverseEvent(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScrollableContent(BuildContext context) {
    return BlocBuilder<DiaryBloc, DiaryState>(
      buildWhen: (previous, current) =>
          current is TarjetasLoaded ||
          current is TarjetasError ||
          current is DiaryLoading,
      builder: (context, state) {
        if (state is DiaryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TarjetasLoaded) {
          final crises = state.crises;
          final eventos = state.ae;

          if (crises.isEmpty && eventos.isEmpty) {
            return const Center(
              child: Text(
                "No hay crisis ni efectos registrados en este día",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          final items = <Widget>[];

          if (crises.isNotEmpty) {
            items.add(_buildSectionHeader("Crisis", crises.length));
            items.addAll(crises.map((c) => CrisisCard(crisis: c)));
            items.add(const SizedBox(height: 16));
          }

          if (eventos.isNotEmpty) {
            items.add(_buildSectionHeader("Eventos Adversos", eventos.length));
            items.addAll(eventos.map((e) => AdverseEventCard(adverseEvent: e)));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: items,
          );
        }

        if (state is TarjetasError) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return const Center(
          child: Text("Selecciona un día para ver los registros"),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAddCrisis(BuildContext context) async {
    final result = await showDialog<Crisis>(
      context: context,
      useRootNavigator: false,
      builder: (_) => const RegisterCrisisDialog(),
    );

    if (result != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! UserLoggedIn) return;

      final userId = authState.user.id!;
      final daySelected = context.read<DiaryBloc>().daySelected;

      final crisis = CrisisModel(
        registeredDate: DateTime.now(),
        crisisDate: daySelected,
        timeRange: result.timeRange,
        quantity: result.quantity,
        type: result.type,
        userId: userId,
      );

      context.read<DiaryBloc>().add(AddCrisisEvent(crisis));
      context.read<DiaryBloc>().add(LoadCalendarEvent(userId));
    }
  }

  Future<void> _handleAddAdverseEvent(BuildContext context) async {
    final result = await showDialog<AdverseEvent>(
      context: context,
      useRootNavigator: false,
      builder: (_) => const RegistroEfectDialog(),
    );

    if (result != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! UserLoggedIn) return;

      final userId = authState.user.id!;
      final daySelected = context.read<DiaryBloc>().daySelected;

      final efecto = AdverseEvent(
        registerDate: DateTime.now(),
        eventDate: daySelected,
        description: result.description,
        userId: userId,
      );

      context.read<DiaryBloc>().add(AddAdverseEventEvent(efecto));
      context.read<DiaryBloc>().add(LoadCalendarEvent(userId));
    }
  }
}
