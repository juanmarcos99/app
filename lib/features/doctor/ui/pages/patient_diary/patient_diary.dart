import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/core.dart';
import 'package:app/features/diary/diary.dart';
import 'package:app/features/diary/ui/bloc/patient_diary_bloc.dart';
import 'package:app/features/diary/ui/pages/dairy/widgets/adverse_event_card.dart';
import 'package:table_calendar/table_calendar.dart';

class PatientDiaryScreen extends StatelessWidget {
  final dynamic patient;

  const PatientDiaryScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientDiaryBloc>(
      create: (context) {
        final bloc = sldiary<PatientDiaryBloc>();
        final patientId = patient.id as int;
        bloc.add(LoadPatientCalendarEvent(patientId));
        bloc.add(
          LoadPatientTarjetasEvent(userId: patientId, date: bloc.daySelected),
        );
        return bloc;
      },
      child: _PatientDiaryView(userId: patient.id as int),
    );
  }
}

class _PatientDiaryView extends StatefulWidget {
  final int userId;

  const _PatientDiaryView({required this.userId});

  @override
  State<_PatientDiaryView> createState() => _PatientDiaryViewState();
}

class _PatientDiaryViewState extends State<_PatientDiaryView> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.surface,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Diario del paciente',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // CALENDARIO READ-ONLY
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 320),
              child: PatientDiaryCalendar(userId: widget.userId),
            ),

            const SizedBox(height: 24),

            // TARJETAS (CRISIS + EVENTOS)
            _buildScrollableContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return BlocBuilder<PatientDiaryBloc, PatientDiaryState>(
      buildWhen: (previous, current) =>
          current is PatientTarjetasLoaded ||
          current is PatientDiaryError ||
          current is PatientDiaryLoading,
      builder: (context, state) {
        if (state is PatientDiaryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PatientTarjetasLoaded) {
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

          if (crises.isNotEmpty) {
            items.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text("Crisis", style: text.titleMedium!),
              ),
            );

            items.addAll(
              crises.map((c) => CrisisCard(crisis: c, isReadOnly: true)),
            );
            items.add(const SizedBox(height: 20));
          }

          if (eventos.isNotEmpty) {
            items.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text("Eventos Adversos", style: text.titleMedium!),
              ),
            );

            items.addAll(
              eventos.map(
                (e) => AdverseEventCard(adverseEvent: e, isReadOnly: true),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          );
        }

        if (state is PatientDiaryError) {
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
}

class PatientDiaryCalendar extends StatefulWidget {
  final int userId;

  const PatientDiaryCalendar({super.key, required this.userId});

  @override
  State<PatientDiaryCalendar> createState() => _PatientDiaryCalendarState();
}

class _PatientDiaryCalendarState extends State<PatientDiaryCalendar> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 380),
        child: BlocBuilder<PatientDiaryBloc, PatientDiaryState>(
          buildWhen: (prev, curr) =>
              curr is PatientCalendarLoaded || curr is PatientDiaryError,
          builder: (context, state) {
            Set<DateTime> crisisDays = {};
            Set<DateTime> aeDays = {};

            if (state is PatientCalendarLoaded) {
              crisisDays = state.crisisDays.toSet();
              aeDays = state.aeDays.toSet();
            }

            return TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),

              onPageChanged: (newFocusedDay) {
                setState(() {
                  focusedDay = newFocusedDay;
                });
              },

              onDaySelected: (day, newFocusedDay) {
                if (day.isAfter(DateTime.now())) return;
                final normalized = DateUtils.dateOnly(day);

                setState(() {
                  selectedDay = normalized;
                  focusedDay = normalized;
                });

                final bloc = context.read<PatientDiaryBloc>();
                bloc.add(SelectPatientDayEvent(normalized));
                bloc.add(
                  LoadPatientTarjetasEvent(
                    userId: widget.userId,
                    date: normalized,
                  ),
                );
              },

              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,

              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: cs.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: cs.onSurface),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: cs.onSurface,
                ),
                headerMargin: const EdgeInsets.only(bottom: 12),
              ),

              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),

              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(4),
                cellPadding: EdgeInsets.zero,
                outsideTextStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.40),
                ),
                defaultTextStyle: TextStyle(color: cs.onSurface, fontSize: 14),
                weekendTextStyle: TextStyle(color: cs.onSurface, fontSize: 14),
                todayDecoration: const BoxDecoration(),
                selectedDecoration: const BoxDecoration(),
              ),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  final normalized = DateUtils.dateOnly(day);
                  return _buildDayCell(
                    cs: cs,
                    day: day,
                    isSelected: false,
                    isToday: false,
                    hasCrisis: crisisDays.contains(normalized),
                    hasAE: aeDays.contains(normalized),
                  );
                },
                todayBuilder: (context, day, _) {
                  final normalized = DateUtils.dateOnly(day);
                  return _buildDayCell(
                    cs: cs,
                    day: day,
                    isSelected: false,
                    isToday: true,
                    hasCrisis: crisisDays.contains(normalized),
                    hasAE: aeDays.contains(normalized),
                  );
                },
                selectedBuilder: (context, day, _) {
                  final normalized = DateUtils.dateOnly(day);
                  return _buildDayCell(
                    cs: cs,
                    day: day,
                    isSelected: true,
                    isToday: isSameDay(day, DateTime.now()),
                    hasCrisis: crisisDays.contains(normalized),
                    hasAE: aeDays.contains(normalized),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayCell({
    required ColorScheme cs,
    required DateTime day,
    required bool isSelected,
    required bool isToday,
    required bool hasCrisis,
    required bool hasAE,
  }) {
    final bool isDisabled = day.isAfter(DateTime.now());

    final Color textColor = isDisabled
        ? cs.onSurface.withValues(alpha: 0.20)
        : isSelected
        ? cs.primary
        : cs.onSurface;

    final Color bgColor = isSelected
        ? cs.primary.withValues(alpha: 0.20)
        : isToday
        ? cs.onSurface.withValues(alpha: 0.08)
        : Colors.transparent;

    return Center(
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasCrisis || hasAE)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasCrisis)
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (hasAE)
                    Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        color: AppColors.errorlight,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
