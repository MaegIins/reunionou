import 'package:flutter/material.dart';
import '../models/Invite.dart';
import '../Singleton/Auth.dart';
import 'invitation_list.dart';
import 'package:partouille/providers/invites_provider.dart';

class InviteDetailsPage extends StatelessWidget {
  final  Invite inviteDetails;

  const InviteDetailsPage({Key? key, required this.inviteDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(inviteDetails.name ?? ''),
      ),
      body: Center(
        child: Text('Détails de l\'invitation'),
      ),
    );
  }
}