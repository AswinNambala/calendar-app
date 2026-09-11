import 'package:calendar_app/feature/calendar/domain/event_model.dart';

abstract class EventRespository {
  Stream<List<EventModel>> watchEventsForMonth({
    required String userId,
    required DateTime month,
  });

  Future<String?> addEvent(EventModel event);

  Future<void> deleteEvent(String eventId);
}
