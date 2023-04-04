class Message {
  final String? id_event;
  final int? idAttendee;
  final String text;
  final DateTime? date;
  final String? username;

  Message({
    this.idAttendee,
    required this.text,
    this.date,
    this.id_event,
    this.username
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      idAttendee: json['id_attendee'],
      text: json['text'],
      date: DateTime.parse(json['date']),
      username: json['username']

    );
  }
}
