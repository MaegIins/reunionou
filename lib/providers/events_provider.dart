import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partouille/Singleton/Auth.dart';
import 'package:partouille/models/event.dart';

class EventsProvider {
  final String apiUrl = 'http://localhost:3333/events';

  Future<List<event>> getEvents(String bearerToken) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{'Authorization': bearerToken},
    );

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = jsonDecode(response.body)['events'];
      final List<event> events = eventsJson.map((eventJson) {
        final eventMap = eventJson['event'];
        final placeMap = eventMap['place'];
        return event(
          id: eventMap['id_event'],
          name: eventMap['name'],
          description: eventMap['description'],
          date: DateTime.parse(eventMap['date']),
          nameOrga: eventMap['name_orga'],
          mailOrga: eventMap['mail_orga'],
          address: placeMap['adress'],
          lat: placeMap['lat'],
          lon: placeMap['lon'],
        );
      }).toList();
      return events;
    } else {
      throw Exception('Failed to load events data');
    }
  }
}

/*
  Future<dynamic> getEventById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load event by ID from API');
    }
  }

  Future<dynamic> addEvent(Map<String, dynamic> event) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(event),
    );
        if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to add event to API');
  }
  }


Future<dynamic> updateEvent(String id, Map<String, dynamic> updatedEvent) async {
final response = await http.put(
Uri.parse('$apiUrl/$id'),
headers: <String, String>{
'Content-Type': 'application/json; charset=UTF-8',
},
body: jsonEncode(updatedEvent),
);if (response.statusCode == 200) {
  final jsonResponse = json.decode(response.body);
  return jsonResponse;
} else {
  throw Exception('Failed to update event on API');
}
}

Future<void> deleteEvent(String id) async {

final response = await http.delete(Uri.parse('$apiUrl/$id'));if (response.statusCode != 204) {
  throw Exception('Failed to delete event from API');
    }
  }

}*/