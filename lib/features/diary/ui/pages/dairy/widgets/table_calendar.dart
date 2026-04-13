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
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 380),
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

              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: cs.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: cs.onSurface),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: cs.onSurface),
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
                outsideTextStyle:
                    TextStyle(color: cs.onSurface.withOpacity(0.40)),
                defaultTextStyle:
                    TextStyle(color: cs.onSurface, fontSize: 14),
                weekendTextStyle:
                    TextStyle(color: cs.onSurface, fontSize: 14),
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
    required bool hasCrisis,
    required bool hasAE,
  }) {
    final bool isDisabled = day.isAfter(DateTime.now());

    final Color textColor = isDisabled
        ? cs.onSurface.withOpacity(0.20)
        : isSelected
            ? cs.primary
            : cs.onSurface;

    final Color bgColor =
        isSelected ? cs.primary.withOpacity(0.20) : Colors.transparent;

    return Center(
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
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
