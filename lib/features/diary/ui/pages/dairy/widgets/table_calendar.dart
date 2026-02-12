import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app/core/theme/style/colors.dart';
import '../../../../diary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';

class DiaryCalendar extends StatefulWidget {
  const DiaryCalendar({super.key});

  @override
  State<DiaryCalendar> createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends State<DiaryCalendar> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  AppColors.white,

      // Espaciado externo del calendario
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

      child: ConstrainedBox(
        // Altura mínima para evitar que el calendario se aplaste
        constraints: const BoxConstraints(
          minHeight: 380,
        ),

        child: BlocBuilder<DiaryBloc, DiaryState>(
          buildWhen: (prev, curr) =>
              curr is CalendarLoaded || curr is CalendarError,
          builder: (context, state) {
            Set<DateTime> crisisDays = {};
            Set<DateTime> aeDays = {};

            if (state is CalendarLoaded) {
              crisisDays = state.crisisDays.toSet();
              aeDays = state.aeDays.toSet();
            }

            return TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              daysOfWeekHeight: 32,
              onDaySelected: (day, newFocusedDay) {
                if (day.isAfter(DateTime.now())) return;
                final normalized = DateUtils.dateOnly(day);

                setState(() {
                  selectedDay = normalized;
                  focusedDay = normalized;
                });

                context.read<DiaryBloc>().add(DayChangeEvent(normalized));

                final authState = context.read<AuthBloc>().state;
                if (authState is UserLoggedIn) {
                  context.read<DiaryBloc>().add(
                    LoadTarjetasEvent(
                      userId: authState.user.id!,
                      date: normalized,
                    ),
                  );

                  context.read<DiaryBloc>().add(
                    LoadCalendarEvent(authState.user.id!),
                  );
                }
              },

              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,

              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),

                // Espaciado inferior del header
                headerMargin: EdgeInsets.only(bottom: 12),
              ),

              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color:  AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color:  AppColors.black,
                  fontWeight: FontWeight.w500,
                ),

                // Espaciado entre días de semana y celdas
                decoration: BoxDecoration(),
              ),

              calendarStyle: CalendarStyle(
                cellMargin: const EdgeInsets.all(4),

                // Altura mínima de cada celda
                cellPadding: const EdgeInsets.symmetric(vertical: 6),

                outsideTextStyle: const TextStyle(color: AppColors.gray400),
                defaultTextStyle: const TextStyle(fontSize: 14),
                weekendTextStyle: const TextStyle(fontSize: 14),
                todayDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                selectedDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
              ),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final normalized = DateUtils.dateOnly(day);
                  final hasCrisis = crisisDays.contains(normalized);
                  final hasAE = aeDays.contains(normalized);

                  return _buildDayCell(
                    day: day,
                    backgroundColor: AppColors.white,
                    hasCrisis: hasCrisis,
                    hasAE: hasAE,
                  );
                },

                todayBuilder: (context, day, focusedDay) {
                  final normalized = DateUtils.dateOnly(day);
                  final hasCrisis = crisisDays.contains(normalized);
                  final hasAE = aeDays.contains(normalized);

                  return _buildDayCell(
                    day: day,
                    backgroundColor: AppColors.surfaceSoft,
                    hasCrisis: hasCrisis,
                    hasAE: hasAE,
                  );
                },

                selectedBuilder: (context, day, focusedDay) {
                  final normalized = DateUtils.dateOnly(day);
                  final hasCrisis = crisisDays.contains(normalized);
                  final hasAE = aeDays.contains(normalized);

                  return _buildDayCell(
                    day: day,
                    backgroundColor: AppColors.primaryLight,
                    hasCrisis: hasCrisis,
                    hasAE: hasAE,
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
    required DateTime day,
    required Color backgroundColor,
    required bool hasCrisis,
    required bool hasAE,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.gray300),
          ),
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(6),
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
            ),
          ),
        ),

        if (hasCrisis)
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

        if (hasAE)
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
