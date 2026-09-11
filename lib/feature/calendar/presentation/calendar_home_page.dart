import 'package:calendar_app/feature/auth/application/auth_controller.dart';
import 'package:calendar_app/feature/calendar/presentation/widgets/daily_event_selection.dart';
import 'package:calendar_app/feature/calendar/presentation/widgets/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/custom_table_calendar.dart';

class CalendarHomeScreen extends ConsumerWidget {
  const CalendarHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Calendar App',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, size: 35),
          ),
        ],
      ),
      body: Column(
        children: [
          const CustomTableCalendar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => showMonthYearPickerSheet(context, ref),
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: const Text('Jump to month/year'),
                  style: TextButton.styleFrom(foregroundColor: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Expanded(child: DailyEventsSection()),
        ],
      ),
    );
  }
}