import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app/core/theme/style/colors.dart';

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
      color: Colors.white, // fondo blanco del calendario
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TableCalendar(
        locale: 'es_ES',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.now(), // 👈 límite: hoy
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (day, newFocusedDay) {
          // 👇 validamos que no sea un día futuro
          if (day.isAfter(DateTime.now())) return;

          setState(() {
            selectedDay = day;
            focusedDay = day;
          });
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

        // Personalización de celdas
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(4),
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.black),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.secundary,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(4),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(4),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
