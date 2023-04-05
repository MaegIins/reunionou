import 'package:flutter/material.dart';
import '../models/Invite.dart';
import '../Singleton/Auth.dart';
import '../providers/invites_provider.dart';
import '../models/inviteConfirm.dart';

import 'home_Page.dart';
/**
 * page to display the details of an invite
 */
class InviteDetailsPage extends StatefulWidget {
  final Invite inviteDetails;

  const InviteDetailsPage({Key? key, required this.inviteDetails})
      : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Détails de l\'invitation',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text( widget.inviteDetails.date ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _selectedOption == true
                        ? Colors.green.shade800
                        : Colors.green,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    'Je viens',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _selectedOption == false
                        ? Colors.red.shade800
                        : Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    'Je ne viens pas',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Ajouter un commentaire (optionnel)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedOption != null) {
                  final bearerToken = "Bearer " + Auth().token;
                  final InviteConfirm = inviteConfirm(
                    idEvent: widget.inviteDetails.id_event,
                    status: _selectedOption!,
                    comment: _comment ?? '',
                  );
                  InvitesProvider()
                      .reponseInvitation(bearerToken, InviteConfirm);

                  // Afficher un message contextuel sur la page de redirection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Votre réponse a été enregistrée")),
                  );

                  // Rediriger vers la page d'accueil et supprimer toutes les routes de la pile
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                'Envoyer la réponse',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
