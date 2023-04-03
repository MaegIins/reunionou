import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/Message.dart';
import '../models/event.dart';

class CommentProvider with ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => [..._messages];

  Future<List<Message>> getComment(
      String bearerToken, event? eventDetails) async {
    final eventUrl = eventDetails?.id.toString();
    final response = await http.get(
      Uri.parse("http://localhost:3333/comments/events/$eventUrl"),
      headers: <String, String>{"Authorization": bearerToken},
    );

    if (response.statusCode == 200) {
      final List<dynamic> messageJson = jsonDecode(response.body)['text'];
      final List<Message> messages = messageJson.map((eventJson) {
        final messageMap = eventJson['text'];
        return Message(
          text: messageMap['text'],
        );
      }).toList();
      return messages;
    } else {
      throw Exception('Failed to load events data');
    }
  }

  Future<void> addMessage(Message message) async {
    final url = 'https://example.com/api/messages';
    final response = await http.post(Uri.parse(url), body: {
      'text': message.text,
    });
    if (response.statusCode == 201) {
      _messages.add(message);
      notifyListeners();
    } else {
      throw Exception('Failed to add message');
    }
  }
}
