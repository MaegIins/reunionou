import 'package:flutter/material.dart';

import '../models/event.dart';

class EventDetailsPage extends StatelessWidget {
  final event? eventDetails;

  const EventDetailsPage({Key? key, required this.eventDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventDetails?.name ?? ''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                width: double.infinity,
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://source.unsplash.com/random/800x600',
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8.0),
                  Text(
                    eventDetails?.date.toString() ?? '',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8.0),
                  Text(
                    'Organisateur: ${eventDetails?.nameOrga ?? ''}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 8.0),
                  Text(
                    'Email organisateur: ${eventDetails?.mailOrga ?? ''}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8.0),
                  Text(
                    'Adresse: ${eventDetails?.address ?? ''}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 8.0),
                  Text(
                    'Latitude: ${eventDetails?.lat ?? ''}, Longitude: ${eventDetails?.lon ?? ''}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                eventDetails?.description ?? '',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
