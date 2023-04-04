import 'package:flutter/material.dart';
import '../models/Invite.dart';
import '../Singleton/Auth.dart';
import 'package:partouille/providers/invites_provider.dart';
import '../models/inviteConfirm.dart';
import 'invitation_list.dart';

class InviteDetailsPage extends StatefulWidget {
  final Invite inviteDetails;

  const InviteDetailsPage({Key? key, required this.inviteDetails}) : super(key: key);

  @override
  _InviteDetailsPageState createState() => _InviteDetailsPageState();
}

class _InviteDetailsPageState extends State<InviteDetailsPage> {
  bool? _selectedOption;
  String? _comment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inviteDetails.name ?? ''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Détails de l\'invitation'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               ElevatedButton(
  onPressed: () {
    setState(() {
      _selectedOption = true;
    });
  },
  style: ElevatedButton.styleFrom(
    primary: _selectedOption == true ? Colors.green.shade800 : Colors.green,
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
  ),
  child: Text('Je viens'),
),
SizedBox(width: 20),
ElevatedButton(
  onPressed: () {
    setState(() {
      _selectedOption = false;
    });
  },
  style: ElevatedButton.styleFrom(
    primary: _selectedOption == false ? Colors.red.shade800 : Colors.red,
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
  ),
  child: Text('Je ne viens pas'),
),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Ajouter un commentaire (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedOption != null) {
                  final bearerToken = "Bearer " + Auth().token;
                  final InviteConfirm = inviteConfirm(
                    idEvent: widget.inviteDetails.id_event,
                    status: _selectedOption!,
                    comment: _comment ?? '',
                  );
                  InvitesProvider().reponseInvitation(bearerToken, InviteConfirm);

                  // Afficher un message contextuel sur la page de redirection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Votre réponse a été enregistrée")),
                  );

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => InvitationListPage(),
                    ),
                  );
                }
              },
              child: Text('Envoyer la réponse'),
            ),
          ],
        ),
      ),
    );
  }
}
