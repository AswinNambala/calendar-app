import 'package:calendar_app/feature/calendar/domain/event_respository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/event_model.dart';

class FirestoreEventRepository implements EventRespository {
  final FirebaseFirestore _firestore;

  FirestoreEventRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _eventsCollection =>
      _firestore.collection('events');

  @override
  Stream<List<EventModel>> watchEventsForMonth({
    required String userId,
    required DateTime month,
  }) {
    final start = DateTime.utc(month.year, month.month, 1);
    final end = DateTime.utc(month.year, month.month + 1, 1);

    return _eventsCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return EventModel(
          id: doc.id,
          title: data['title'] as String,
          date: (data['date'] as Timestamp).toDate(),
          userId: data['userId'] as String,
        );
      }).toList();
    });
  }

  @override
  Future<void> addEvent(EventModel event) async {
    await _eventsCollection.add({
      'title': event.title,
      'date': Timestamp.fromDate(event.date),
      'userId': event.userId,
    });
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }
}