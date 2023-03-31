import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partouille/Singleton/Auth.dart';
import 'package:partouille/models/event.dart';
import 'package:partouille/models/eventAdress.dart';
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

Future<void> addEvent(String bearerToken, EventAdress eventAdress) async {

  final String apiUrl1 = 'http://localhost:3333/events';

  print(eventAdress.address.city);
  print(bearerToken);
  final response = await http.post(
    Uri.parse(apiUrl1),
    headers: <String, String>{
      'Authorization': bearerToken,
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': eventAdress.name,
      'description': eventAdress.description,
      'date': {
        'date': eventAdress.date.toIso8601String().substring(0, 10),
        'time': eventAdress.date.toIso8601String().substring(11, 16),
      },
      'name_place': eventAdress.namePlace,
      'adress': {
        'street': eventAdress.address.street,
        'city': eventAdress.address.city,
      },
    }),
  );

  if (response.statusCode != 201 && response.statusCode != 302 && response.statusCode != 200) {
    throw Exception('Failed to add event');
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