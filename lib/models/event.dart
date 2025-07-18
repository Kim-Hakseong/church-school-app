class Event {
  final DateTime date;
  final String title;
  final String? note;

  Event({
    required this.date,
    required this.title,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'title': title,
      'note': note,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      title: json['title'],
      note: json['note'],
    );
  }

  @override
  String toString() {
    return 'Event(date: $date, title: $title, note: $note)';
  }
}
