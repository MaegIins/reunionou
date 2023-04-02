import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:partouille/models/event.dart';
import '../providers/events_provider.dart';
import '../Singleton/Auth.dart';
import 'EventDetailsPage.dart';
import 'event_form.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data as List<event>;

          final markers = events.map((event) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(event.lat!, event.lon!),
              builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventDetailsPage(eventDetails: event),
                    ),
                  );
                },
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50.0,
                ),
              ),
            );
          }).toList();

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: // position metz
                          LatLng(49.119, 6.175),
                      zoom: 13.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(markers: markers),
                    ],
                  ),
                ),
                SizedBox(height: 13.0),
                if (Auth().token != "")
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventForm()),
                      );
                    },
                    child: Text('Ajouter un événement'),
                  ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement des événements'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<event>> _loadEvents() async {
    final auth = Auth();

    if (!auth.isAuthenticated) {
      return Future.value([]);
    }

    final bearerToken = "Bearer " + auth.token;
    final events = await EventsProvider().getEvents(bearerToken);
    return events;
  }
}
