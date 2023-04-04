import 'package:flutter/material.dart';
import '../providers/events_provider.dart';
import '../Singleton/Auth.dart';
import '../models/event.dart';
import 'EventDetailsPage.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bearerToken = "Bearer " + Auth().token;

    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des événements"),
      ),
      body: FutureBuilder<List<event>>(
        future: EventsProvider().getEvents(bearerToken),
        builder: (BuildContext context, AsyncSnapshot<List<event>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final events = snapshot.data;
            return ListView.separated(
              padding: EdgeInsets.all(16.0),
              itemCount: events?.length ?? 0,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 16.0,
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final event = events![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventDetailsPage(eventDetails: event),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          event.description ?? '',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
