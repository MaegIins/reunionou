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
      final List<dynamic> messageJson = jsonDecode(response.body);
      final List<Message> messages =
          messageJson.map((json) => Message.fromJson(json)).toList();
      _messages = messages;
      notifyListeners();
      return messages;
    } else {
      List<Message> messages = [];
      _messages = messages;
      return messages;
    }
  }

  Future<void> addMessage(
      String bearerToken, event? idevent, Message message) async {
    final url = 'http://localhost:3333/comments/add';
    final response = await http.post(Uri.parse(url), body: {
      'id_event': idevent?.id,
      'text': message.text,
    }, headers: <String, String>{
      "Authorization": bearerToken
    });

    if (response.statusCode == 201 || response.statusCode == 302) {
      // Fetch the updated message list from the server

      final updatedMessages = await getComment(bearerToken, idevent);
      print(updatedMessages);
      // Update the local list and notify listeners
      _messages = updatedMessages;
      notifyListeners();
    } else {
      throw Exception('Failed to add message');
    }
  }
}
