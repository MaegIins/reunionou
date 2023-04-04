import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Singleton/Auth.dart';
import 'invitation_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isConnected = Auth().token != "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Page de profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              isConnected
                  ? Text(
                      'Email : ${Auth().email}',
                      style: TextStyle(fontSize: 18),
                    )
                  : Text(
                      'Vous n\'êtes pas connecté',
                      style: TextStyle(fontSize: 18),
                    ),
              SizedBox(height: 16),
              if (isConnected)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvitationListPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Voir la liste d\'invitations',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
