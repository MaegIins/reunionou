import 'package:flutter/material.dart';
import 'invitation_list.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page de profil'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvitationListPage(),
                  ),
                );
              },
              child: Text('Voir la liste d\'invitations'),
            ),
          ],
        ),
      ),
    );
  }
}
