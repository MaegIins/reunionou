class Invite {
  final String? name;
  final String email;
  final String id_event;
  final String date;

  Invite({
    required this.name,
    required this.email,
    required this.id_event,
    required this.date,
  });

  /*factory Invite.fromJson(Map<String, dynamic> json) {
    final mailUser = json['mail_user'] as String;
    final eventsJson = json['events'] as List<dynamic>;
    final events = eventsJson.map((eventJson) {
      final eventMap = eventJson['event'] as Map<String, dynamic>;
      final idEvent = eventMap['id_event'] as String;
      final name = eventMap['name'] as String;
      return Invite(name: name, email: mailUser, id_event: idEvent);
    }).toList();
    return events.first;
  }*/
}
