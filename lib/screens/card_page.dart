import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:partouille/models/event.dart';
import '../providers/events_provider.dart';
import '../Singleton/Auth.dart';
import 'EventDetailsPage.dart';
import 'event_form.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late Future<List<event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _loadEvents();
  }

   Future<void> _reloadEvents() async {
    setState(() {
      _eventsFuture = _loadEvents();
    });
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _eventsFuture,
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
                      center: LatLng(49.119, 6.175), // position metz
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
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                         MaterialPageRoute(builder: (context) => EventForm(reloadEvents: _reloadEvents)),
                      );
                      if (result == true) {
                        setState(() {
                          _eventsFuture = _loadEvents();
                        });
                      }
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
