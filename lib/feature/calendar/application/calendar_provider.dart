import 'package:calendar_app/feature/auth/data/auth_respository.dart';
import 'package:calendar_app/feature/calendar/data/firestore_event_respository.dart';
import 'package:calendar_app/feature/calendar/domain/event_respository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../domain/event_model.dart';
import 'calendar_state.dart';

// --- Infrastructure ---

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final eventRepositoryProvider = Provider<EventRespository>((ref) {
  return FirestoreEventRepository(ref.watch(firestoreProvider));
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.asData?.value?.uid;
});

// --- Calendar UI state (focused day, selected day, format) ---

class CalendarNotifier extends Notifier<CalendarState> {
  @override
  CalendarState build() => CalendarState.initial();

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    state = state.copyWith(selectedDay: selectedDay, focusedDay: focusedDay);
  }

  void changeFocusedDay(DateTime focusedDay) {
    state = state.copyWith(focusedDay: focusedDay);
  }

  void jumpToMonthYear(int year, int month) {
    state = state.copyWith(focusedDay: DateTime(year, month, 1));
  }

  void changeFormat(CalendarFormat format) {
    state = state.copyWith(calendarFormat: format);
  }
}

final calendarNotifierProvider =
    NotifierProvider<CalendarNotifier, CalendarState>(CalendarNotifier.new);

// --- Events for the currently focused month ---

final eventsForMonthProvider =
    StreamProvider.autoDispose<List<EventModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final focusedDay = ref.watch(
      calendarNotifierProvider.select((state) => state.focusedDay));
  final repository = ref.watch(eventRepositoryProvider);

  if (userId == null) return const Stream.empty();

  return repository.watchEventsForMonth(userId: userId, month: focusedDay);
});

final eventsByDayProvider =
    Provider.autoDispose<Map<DateTime, List<EventModel>>>((ref) {
  final eventsAsync = ref.watch(eventsForMonthProvider);
  final events = eventsAsync.value ?? const [];

  final map = <DateTime, List<EventModel>>{};
  for (final event in events) {
    final key = DateTime.utc(event.date.year, event.date.month, event.date.day);
    map.putIfAbsent(key, () => []).add(event);
  }
  return map;
});

// --- Event actions (add/delete) ---

class EventActions {
  final Ref ref;
  EventActions(this.ref);

  Future<void> addEvent(String title, DateTime date) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null || title.trim().isEmpty) return;

    final repository = ref.read(eventRepositoryProvider);
    await repository.addEvent(EventModel(
      id: '', 
      title: title.trim(),
      date: DateTime.utc(date.year, date.month, date.day),
      userId: userId,
    ));
  }

  Future<void> deleteEvent(String eventId) async {
    final repository = ref.read(eventRepositoryProvider);
    await repository.deleteEvent(eventId);
  }
}

final eventActionsProvider = Provider<EventActions>((ref) {
  return EventActions(ref);
});