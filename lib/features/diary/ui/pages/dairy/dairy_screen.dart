import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
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
      LoadTarjetasEvent(
        userId: userId,
        date: context.read<DiaryBloc>().daySelected,
      ),
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
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
        backgroundColor: cs.surface,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------------------------------------------------------
              // CALENDARIO PREMIUM
              // ---------------------------------------------------------
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 320),
                child: const DiaryCalendar(),
              ),

              const SizedBox(height: 20),

              // ---------------------------------------------------------
              // BOTONES PREMIUM
              // ---------------------------------------------------------
              _buildActionButtons(context),

              const SizedBox(height: 24),

              // ---------------------------------------------------------
              // TARJETAS (CRISIS + EVENTOS)
              // ---------------------------------------------------------
              _buildScrollableContent(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // BOTONES PREMIUM
  // ---------------------------------------------------------
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
                backgroundColor: AppColors.errorlight,
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
                icon: Icons.monitor_heart_outlined,
                backgroundColor: AppColors.primary,
                onPressed: () => _handleAddCrisis(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomActionButton(
                text: "Añadir Efecto",
                icon: Icons.add,
                backgroundColor: AppColors.errorlight,
                onPressed: () => _handleAddAdverseEvent(context),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------
  // CONTENIDO SCROLLEABLE (CRISIS + EVENTOS)
  // ---------------------------------------------------------
  Widget _buildScrollableContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
            return Center(
              child: Text(
                "No hay crisis ni efectos registrados",
                style: Theme.of(context).textTheme.bodySmall!,
                textAlign: TextAlign.center,
              ),
            );
          }

          final items = <Widget>[];

          // ---------------------------------------------------------
          // SECCIÓN CRISIS
          // ---------------------------------------------------------
          if (crises.isNotEmpty) {
            items.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  "Crisis",
                  style: text.titleMedium!,
                ),
              ),
            );

            items.addAll(crises.map((c) => CrisisCard(crisis: c)));
            items.add(const SizedBox(height: 20));
          }

          // ---------------------------------------------------------
          // SECCIÓN EVENTOS ADVERSOS (SIN CONTADOR)
          // ---------------------------------------------------------
          if (eventos.isNotEmpty) {
            items.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  "Eventos Adversos",
                  style: text.titleMedium!,
                ),
              ),
            );

            items.addAll(eventos.map((e) => AdverseEventCard(adverseEvent: e)));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          );
        }

        if (state is TarjetasError) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return Center(
          child: Text(
            "Selecciona un día para ver los registros",
            style: text.bodyLarge,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // LÓGICA PARA AÑADIR CRISIS
  // ---------------------------------------------------------
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

  // ---------------------------------------------------------
  // LÓGICA PARA AÑADIR EVENTO ADVERSO
  // ---------------------------------------------------------
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
