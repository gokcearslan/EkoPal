import 'package:flutter/material.dart';
import 'package:ekopal/services/event_model.dart';

import 'colors.dart';

class DetailedEventPage extends StatelessWidget {
  final Event event;
  final bool isCurrentUser; // Assume this determines if the current user created the event

  DetailedEventPage({required this.event, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white, // Ensure 'white' is defined or use Colors.white directly

      appBar: AppBar(
        title: const Text("Etkinlik detayları",
          style: TextStyle(
            fontSize: 26,
          ),),
        backgroundColor: appBarColor,
      ),
      body:SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            color: cardColor, // Ensure 'cardColor' is defined

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    event.eventName,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Image.network(
                  'https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg',
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    event.additionalInfo,
                    style: TextStyle(color:Colors.black,fontSize:20),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(event.eventDate),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(event.organizer),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(event.location),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Created by: gokce',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('İletişime geç'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('Düzenle'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

}
