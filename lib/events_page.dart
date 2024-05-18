import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/detailed_event_page.dart';

import 'colors.dart';
import 'create_page.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event>? events;
  String? userRole;
  StreamSubscription<List<Event>>? eventsSubscription;



  @override
  void initState() {
    super.initState();
    fetchUserRole();
    eventsSubscription = EventService().getEventsStream().listen(
            (updatedEvents) {
          if (mounted) {
            setState(() {
              events = updatedEvents;
            });
          }
        },
        onError: (error) {
          print("Error fetching events stream: $error");
        }
    );
  }
  Future<void> fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
        Map<String, dynamic> userData = userDocSnapshot.data()! as Map<String, dynamic>;
        setState(() {
          userRole = userData['role'] as String?;
        });
      }
    }
  }
  @override
  void dispose() {
    eventsSubscription?.cancel(); // Cancel the subscription
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor:white,
      appBar: AppBar(
        title: const Text('Etkinlikler',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: events == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: events!.length,
        itemBuilder: (context, index) {
          return buildEventCard(events![index]);
        },
      ),

      floatingActionButton: userRole == 'staff' ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreatePage(initialCategory: 'Etkinlik')));
        },
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
        ),
        backgroundColor: lightButtonColor,
      ) : null,
    );
  }

  Widget buildEventCard(Event event) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 5.0,
      color:cardColor,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column for the Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://files.sikayetvar.com/lg/cmp/93/9386.png?1522650125',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.eventName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.location,
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  // Date Information
                  Text(
                    event.eventDate, // Date information
                    style: theme.textTheme.bodyText2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*IconButton(
                        icon: Icon(
                          event.isFavorite ? Icons.star : Icons.star_border,
                          color: event.isFavorite ? Colors.amber : colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            event.isFavorite = !event.isFavorite;
                          });
                        },
                      ),

                       */


                      IconButton(
                        icon: Icon(
                          Icons.article_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedEventPage(event: event),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }












}
