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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
            ),

            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(2),
              outsideTextStyle: const TextStyle(color: Colors.grey),
            ),

            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.black),
            ),

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final normalized = DateUtils.dateOnly(day);
                final hasCrisis = crisisDays.contains(normalized);
                final hasAE = aeDays.contains(normalized);

                return _buildDayCell(
                  day: day,
                  backgroundColor: Colors.white,
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
                  backgroundColor: AppColors.calendarActualDay,
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
    );
  }

  /// 🔥 Construye un día con barritas de crisis y eventos adversos
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
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(4),
          child: Text(
            '${day.day}',
            style: const TextStyle(color: Colors.black),
          ),
        ),

        /// Crisis (azul)
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

        /// Evento adverso (morado)
        if (hasAE)
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secundary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
