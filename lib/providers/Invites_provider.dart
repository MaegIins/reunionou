import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partouille/models/Invite.dart';
import 'package:partouille/models/event.dart';
import 'package:partouille/models/inviteConfirm.dart';

class InvitesProvider {
  Future<void> inviteAttendee(
      bearerToken, event? eventInvite, String email) async {
    final url = 'http://docketu.iutnc.univ-lorraine.fr:20005/invites/user';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mail': email,
        'event': eventInvite?.id,
      }),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      print('Invitation envoyée avec succès !');
    } else {
      throw Exception(
          'Erreur lors de l\'envoi de l\'invitation : ${response.statusCode}');
    }
  }

  Future<List<Invite>> getInvitesList(String bearerToken) async {
    final url =
        'http://docketu.iutnc.univ-lorraine.fr:20005/invites/list?state=0';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      final invitesJsonMailUser = jsonDecode(response.body);
      final List<dynamic> invitesJson = jsonDecode(response.body)['events'];
      final List<Invite> invites = invitesJson.map((inviteJson) {
        final inviteMap = inviteJson['event'];
        final placeMap = inviteMap['place'];
        return Invite(
          email: invitesJsonMailUser['mail_user'],
          name: placeMap['name'],
          id_event: inviteMap['id_event'],
        );
      }).toList();
      return invites;
    } else {
      throw Exception(
          'Erreur lors de la récupération de la liste d\'invitations : ${response.statusCode}');
    }
  }

  Future<void> reponseInvitation(
      String bearerToken, inviteConfirm inviteConfirm) async {
    final url =
        'http://docketu.iutnc.univ-lorraine.fr:20005/invites/confirm/user';
    print(inviteConfirm.status);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'event': inviteConfirm.idEvent,
        'status': inviteConfirm.status,
        'comment': inviteConfirm.comment,
      }),
    );

    if (response.statusCode == 200) {
      print('Réponse envoyée avec succès !');
    } else {
      print('Erreur lors de l\'envoi de la réponse : ${response.statusCode}');
    }
  }
}
