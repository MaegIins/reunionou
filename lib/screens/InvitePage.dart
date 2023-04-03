import 'package:flutter/material.dart';

import 'package:partouille/providers/invites_Provider.dart';
import '../Singleton/Auth.dart';
import '../models/event.dart';

class InvitePage extends StatefulWidget {
    final event? eventDetails;

  InvitePage({Key? key, required this.eventDetails}) : super(key: key);
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final InvitesProvider _invitesProvider = InvitesProvider();
  bool _isSendingInvitation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inviter un utilisateur'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email de l\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse email';
                    }
                    if (!value.contains('@')) {
                      return 'Veuillez entrer une adresse email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                if (_isSendingInvitation)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!_isSendingInvitation)
                  Center(
                    child: ElevatedButton(
                      onPressed: _sendInvitation,
                      child: Text('Envoyer l\'invitation'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendInvitation() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSendingInvitation = true;
      });
      try {
        final email = _emailController.text;
        final eventDetails = widget.eventDetails;
        print(eventDetails?.id);
        final bearerToken = "Bearer " + Auth().token;
        
        await _invitesProvider.inviteAttendee(bearerToken, eventDetails!, email );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitation envoyée avec succès à $email'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi de l\'invitation'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSendingInvitation = false;
        });
      }
    }
  }
}
