import 'package:flutter/material.dart';
import 'package:partouille/providers/invites_provider.dart';
import 'package:partouille/models/Invite.dart';
import '../Singleton/Auth.dart';

class InvitationListPage extends StatefulWidget {
  const InvitationListPage({Key? key}) : super(key: key);

  @override
  _InvitationListPageState createState() => _InvitationListPageState();
}

class _InvitationListPageState extends State<InvitationListPage> {
  late Future<List<Invite>> _futureInvitesList;

  @override
  void initState() {
    super.initState();
    _futureInvitesList = InvitesProvider().getInvitesList("Bearer " + Auth().token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste d\'invitations'),
      ),
      body: Center(
        child: FutureBuilder<List<Invite>>(
          future: _futureInvitesList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final invites = snapshot.data!;
              return ListView.separated(
                itemCount: invites.length,
                itemBuilder: (BuildContext context, int index) {
                  final invite = invites[index];
                  return ListTile(
                    title: Text(invite.name!),
                    subtitle: Text('repondre à cette invitation '),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.transparent),
              );
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else {
              return Text('Aucune invitation trouvée');
            }
          },
        ),
      ),
    );
  }
}
