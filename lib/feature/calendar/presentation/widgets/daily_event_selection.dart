import 'package:calendar_app/feature/calendar/application/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_event_dialog.dart';

class DailyEventsSection extends ConsumerWidget {
  const DailyEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarNotifierProvider);
    final eventsByDay = ref.watch(eventsByDayProvider);
    final eventsAsync = ref.watch(eventsForMonthProvider);
    final selectedDay = calendarState.selectedDay;

    final key = selectedDay != null
        ? DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day)
        : null;
    final dayEvents = key != null ? (eventsByDay[key] ?? []) : [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedDay != null
                      ? 'Events on ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}'
                      : 'Select a day',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: selectedDay == null
                    ? null
                    : () => showAddEventDialog(context, ref, forDay: selectedDay),
                icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Could not load events',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ),
              data: (_) {
                if (dayEvents.isEmpty) {
                  return Center(
                    child: Text(
                      'No events for this day',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: dayEvents.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, color: Colors.orange, size: 10),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                ref.read(eventActionsProvider).deleteEvent(event.id),
                            icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}