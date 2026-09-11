class EventModel {
  String id;
  String title;
  DateTime date;
  String userId;
  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.userId,
  });

  factory EventModel.fromJson(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] as String,
      date: map['date'] as DateTime,
      userId: map['userId'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date, 'userId': userId};
  }

  EventModel copyWith({String? title, DateTime? date}) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      userId: userId,
    );
  }
}
