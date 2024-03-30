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
                      fontSize: 29.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Image card with darkened filter
                Card(
                  elevation: 4.0,
                  child: Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), // Adjust the opacity to make the image darker
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    event.additionalInfo,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    event.eventDate,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    event.location,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    event.organizer,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Created by: gokce', // Replace with dynamic data if available
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('Message'),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert), // Three vertical dots icon
                        onPressed: () {
                          // TODO: Implement navigation to editing page or show more options
                        },
                      ),
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
