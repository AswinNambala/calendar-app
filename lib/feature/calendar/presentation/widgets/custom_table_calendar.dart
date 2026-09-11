import 'package:calendar_app/feature/calendar/application/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends ConsumerWidget {
  const CustomTableCalendar({super.key});

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarNotifierProvider);
    final notifier = ref.read(calendarNotifierProvider.notifier);
    final eventsByDay = ref.watch(eventsByDayProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        sixWeekMonthsEnforced: true,
        focusedDay: calendarState.focusedDay,
        firstDay: DateTime.utc(1990),
        lastDay: DateTime.utc(2040),
        calendarFormat: calendarState.calendarFormat,
        selectedDayPredicate: (day) =>
            calendarState.selectedDay != null &&
            isSameDay(calendarState.selectedDay, day),
        eventLoader: (day) {
          final key = DateTime.utc(day.year, day.month, day.day);
          return eventsByDay[key] ?? [];
        },
        onDaySelected: notifier.selectDay,
        onPageChanged: notifier.changeFocusedDay,
        onFormatChanged: notifier.changeFormat,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonShowsNext: false,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          formatButtonDecoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: const TextStyle(color: Colors.black87, fontSize: 13),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black87),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black87),
          titleTextFormatter: (date, locale) =>
              "${_monthName(date.month)} ${date.year}",
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
          weekendStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
          todayDecoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          selectedDecoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          markerDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
          markersMaxCount: 3,
          defaultTextStyle: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}