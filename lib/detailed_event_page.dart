import 'package:flutter/material.dart';
import 'package:ekopal/services/event_model.dart';

class DetailedEventPage extends StatelessWidget {
  final Event event;
  final bool isCurrentUser; // Assume this determines if the current user created the event

  DetailedEventPage({required this.event, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    event.eventName,
                    style: TextStyle(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    event.additionalInfo,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Created by: gokce ', // Assuming 'creatorName' exists in your Event model
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('Message'),

                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('Edit'),
                        /* USER condition eklenince burası kullılacak
                      if (isCurrentUser) // Conditional edit button
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Implement navigation to editing page
                          },
                        ),

                       */
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
