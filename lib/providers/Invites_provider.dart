import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partouille/models/Invite.dart';

class InvitesProvider {


  Future<void> inviteAttendee(bearerToken , Invite Invite) async {
    final url = 'http://localhost:3333/invites/user';

    final response = await http.post(
      Uri.parse(url),
      headers: {
      'Authorization': bearerToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mail': Invite.email,
        'event': Invite.id_event,
      }),
    );

    if (response.statusCode == 200) {
      print('Invitation envoyée avec succès !');
    } else {
      print('Erreur lors de l\'envoi de l\'invitation : ${response.statusCode}');
    }
  }


   
  Future<List<Invite>> getInvitesList(String bearerToken) async {
    final url = 'http://localhost:3333/invites/list?state=0';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as List<dynamic>;
      final invites = jsonBody.map((json) => Invite.fromJson(json)).toList();

      return invites;
    } else {
      throw Exception('Erreur lors de la récupération de la liste d\'invitations : ${response.statusCode}');
    }
  }
}

