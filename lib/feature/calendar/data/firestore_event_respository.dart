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
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return EventModel(
              id: doc.id,
              title: data['title'] as String,
              date: (data['date'] as Timestamp).toDate(),
              userId: data['userId'] as String,
              reminderTime: data['reminderTime'] != null
                  ? (data['reminderTime'] as Timestamp).toDate()
                  : null,
            );
          }).toList();
        });
  }

  @override
  Future<String?> addEvent(EventModel event) async {
    final docRef = await _eventsCollection.add({
      'title': event.title,
      'date': Timestamp.fromDate(event.date),
      'userId': event.userId,
      'reminderTime': event.reminderTime != null
          ? Timestamp.fromDate(event.reminderTime!)
          : null,
    });
    return docRef.id;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }
}
