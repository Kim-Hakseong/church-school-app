class Verse {
  final DateTime date;
  final String text;
  final String? extra;

  Verse({
    required this.date,
    required this.text,
    this.extra,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'text': text,
      'extra': extra,
    };
  }

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      text: json['text'],
      extra: json['extra'],
    );
  }

  @override
  String toString() {
    return 'Verse(date: $date, text: $text, extra: $extra)';
  }
}
