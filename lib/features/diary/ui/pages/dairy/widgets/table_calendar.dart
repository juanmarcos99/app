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
      color: AppColors.primary, // 👈 fondo azul detrás del calendario
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TableCalendar(
        locale: 'es_ES',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (day, newFocusedDay) {
          setState(() {
            selectedDay = day;
            // 👇 siempre actualizar el mes enfocado
            focusedDay = day;
          });
        },
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(2),

          // 👇 Días del mes actual
          defaultDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),

          // 👇 Día seleccionado
          selectedDecoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),

          // 👇 Día actual
          todayDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.deepOrange, width: 2),
          ),

          // 👇 Texto de días del mes actual
          defaultTextStyle: const TextStyle(color: Colors.black),
          weekendTextStyle: const TextStyle(color: Colors.black),
          selectedTextStyle: const TextStyle(color: Colors.white),
          todayTextStyle: const TextStyle(color: Colors.black),

          // 👇 Días de otro mes (fuera del mes actual)
          outsideDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          outsideTextStyle: const TextStyle(color: Colors.grey), // 👈 letra gris
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.white,
          ), // días LUN-VIE en blanco
          weekendStyle: TextStyle(
            color: Colors.white,
          ), // días SÁB-DOM en blanco
        ),
      ),
    );
  }
}
