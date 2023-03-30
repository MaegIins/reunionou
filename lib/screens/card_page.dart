import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'event_form.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(48.8566, 2.3522), // Paris, France
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(48.8584, 2.2945), // Tour Eiffel
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Tour Eiffel"),
                                content: Text(
                                    'La Tour Eiffel est une tour de fer puddlé \nde 324 mètres de hauteur située à Paris,\n à l’extrémité nord-ouest du parc du Champ-de-Mars \n en bordure de la Seine dans le 7ᵉ arrondissement.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Fermer'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 50.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 13.0),
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
  }
}
