import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EventListPage extends StatelessWidget {
  const EventListPage({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page de eventslist'),
    );
  }
}

 // return hello world
 
  /*
  const EventListPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getEventData() async {
    final url = Uri.parse('http://localhost:3332/events/7904c62f-3d4f-446f-8a23-56c5660f466f');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Si la requête est réussie, convertir la réponse en un objet Map et la renvoyer.
      return jsonDecode(response.body);
    } else {
      // Si la requête échoue, lever une exception.
      throw Exception('Failed to load event data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getEventData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final eventData = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom de l\'événement : ${eventData['event']['name']}'),
              Text('Description : ${eventData['event']['description']}'),
              Text('Date : ${eventData['event']['date']}'),
              Text('Organisateur : ${eventData['event']['name_orga']}'),
              Text('Adresse email de l\'organisateur : ${eventData['event']['mail_orga']}'),
              Text('Nom du lieu : ${eventData['place'][0]['name']}'),
              Text('Adresse du lieu : ${eventData['place'][0]['adress']}'),
              Text('Latitude : ${eventData['place'][0]['lat']}'),
              Text('Longitude : ${eventData['place'][0]['lon']}'),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
*/
