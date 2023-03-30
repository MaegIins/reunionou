import 'package:flutter/material.dart';

import '../providers/events_provider.dart';
import '../Singleton/Auth.dart';
import '../models/event.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bearerToken = "Bearer " + Auth().token;

    return FutureBuilder<List<event>>(
      future: EventsProvider().getEvents(bearerToken),
      builder: (BuildContext context, AsyncSnapshot<List<event>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final events = snapshot.data;
          return ListView.builder(
            itemCount: events?.length,
            itemBuilder: (BuildContext context, int index) {
              final event = events?[index];
              return ListTile(
                title: Text(event?.name ?? ''),
                subtitle: Text(event?.description ?? ''),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erreur : ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
