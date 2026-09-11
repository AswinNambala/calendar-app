class EventModel {
  String id;
  String title;
  DateTime date;
  String userId;
  DateTime? reminderTime;
  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.userId,
    this.reminderTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] as String,
      date: map['date'] as DateTime,
      userId: map['userId'] as String,
      reminderTime: map['reminderTime'] as DateTime,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'userId': userId,
      'reminderTime': reminderTime,
    };
  }

  EventModel copyWith({String? title, DateTime? date, DateTime? reminderTime}) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      userId: userId,
      reminderTime: reminderTime ?? this.reminderTime
    );
  }
  bool get hasReminder => reminderTime != null;
}
