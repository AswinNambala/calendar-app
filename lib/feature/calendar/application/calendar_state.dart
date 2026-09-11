import 'package:table_calendar/table_calendar.dart';

class CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;

  const CalendarState({
    required this.focusedDay,
    required this.selectedDay,
    this.calendarFormat = CalendarFormat.month,
  });

  factory CalendarState.initial() {
    final now = DateTime.now();
    return CalendarState(focusedDay: now, selectedDay: now);
  }

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}