import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event.dart';
import 'EventDetailsPage.dart';

class EventParticipantsPage extends StatefulWidget {
  final event? eventDetails;

  const EventParticipantsPage({Key? key, required this.eventDetails})
      : super(key: key);

  @override
  _EventParticipantsPageState createState() => _EventParticipantsPageState();
}

class _EventParticipantsPageState extends State<EventParticipantsPage> {
  List<dynamic> _participantsList = [];

  @override
  void initState() {
    super.initState();
    _getParticipantsList();
  }

  void _getParticipantsList() async {
    final response = await http.post(Uri.parse(
        'http://localhost:3333/events/${widget.eventDetails?.id}/attendees'));
    if (response.statusCode == 200) {
      setState(() {
        _participantsList = json.decode(response.body);
      });
    } else {
      // Gestion des erreurs
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
          padding: EdgeInsets.all(16.0),
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
                    return ListTile(
                      title: Text(participant['name']),
                      subtitle: Text(participant['email']),
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
