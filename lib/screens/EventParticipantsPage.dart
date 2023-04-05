import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:partouille/models/event.dart';
import 'package:partouille/models/attendee.dart';
import 'package:partouille/providers/events_provider.dart';
import 'package:partouille/Singleton/Auth.dart';
import 'package:partouille/models/attendee.dart';
/**
 * Widget to display the participants of an event
 */
class EventParticipantsPage extends StatefulWidget {
  final event? eventDetails;

  const EventParticipantsPage({Key? key, required this.eventDetails})
      : super(key: key);

  @override
  _EventParticipantsPageState createState() => _EventParticipantsPageState();
}

class _EventParticipantsPageState extends State<EventParticipantsPage> {
  List<attendee> _participantsList = [];

  @override
  void initState() {
    super.initState();
    getParticipants();
  }
/**
 * function to get the participants of an event
 */
  Future<void> getParticipants() async {
    final bearerToken = "Bearer " + Auth().token;
    try {
      final attendees = await EventsProvider()
          .getEventAttendees(bearerToken, widget.eventDetails!);
      print(attendees);
      setState(() {
        _participantsList = attendees;
      });
    } catch (e) {
      print('Error fetching participants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liste des participants:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (_participantsList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _participantsList.length,
                  itemBuilder: (context, index) {
                    final participant = _participantsList[index];
                    String statusText = "";
                    if (participant.status == 0) {
                      statusText = "En attente de réponse";
                    } else if (participant.status == 1) {
                      statusText = "Accepté";
                    } else if (participant.status == 2) {
                      statusText = "Je ne viens pas";
                    } else if (participant.status == 3) {
                      statusText = "Organisateur";
                    }
                    return ListTile(
                      title: Text(participant.nameUser ?? ''),
                      subtitle: Text(participant.mailUser ?? ''),
                      trailing: Text(statusText),
                    );
                  },
                ),
              if (_participantsList.isEmpty)
                Text('Aucun participant inscrit à cet événement'),
            ],
          ),
        ),
      ),
    );
  }
}
