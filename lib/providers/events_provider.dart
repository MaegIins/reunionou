import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:partouille/Singleton/Auth.dart';
import 'package:partouille/models/event.dart';
import 'package:partouille/models/eventAdress.dart';
import 'package:partouille/models/attendee.dart';

/**
 * EventsProvider
 * 
 * This class is used to fetch events data from the API
 * 
 */
class EventsProvider {
  final String apiUrl = 'http://localhost:3333/events';

/**
 * getEvents
 * this function is used to fetch events data from the API
 */
  Future<List<event>> getEvents(String bearerToken) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{"Authorization": bearerToken},
    );

    print(response.statusCode);
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
      final List<event> events = [];
      return events;
    }
  }

/**
 * addEvent
 * this function is used to add an event to the API
 */
  Future<void> addEvent(String bearerToken, EventAdress eventAdress) async {
    final String apiUrl1 = 'http://localhost:3333/events';
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

    if (response.statusCode != 201 &&
        response.statusCode != 302 &&
        response.statusCode != 200) {
      throw Exception('Failed to add event');
    }
  }

/**
 * getEventAttendees
 * this function is used to fetch attendees data from the API
 */
  Future<List<attendee>> getEventAttendees(
      String bearerToken, event eventId) async {
    final eventUrl = eventId.id.toString();

    final String apiUrl2 = 'http://localhost:3333/events/$eventUrl/attendees';
    print(apiUrl2);
    final response = await http.get(
      Uri.parse(apiUrl2),
      headers: <String, String>{
        'Authorization': bearerToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> attendeesJson = jsonDecode(response.body);
      print(attendeesJson);
      final List<attendee> attendees = attendeesJson.map((attendeeJson) {
        return attendee(
          nameUser: attendeeJson['name_user'],
          mailUser: attendeeJson['mail_user'],
          status: attendeeJson['status'],
        );
      }).toList();
      return attendees;
    } else {
      throw Exception('Failed to load attendees data');
    }
  }
}
// 0 on sait pas , 1 c'est ok, 2 c'est pas ok