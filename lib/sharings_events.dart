import 'package:ekopal/services/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'detailed_event_page.dart';

class SharingViewEvents extends StatefulWidget {
  @override
  _SharingViewEventsState createState() => _SharingViewEventsState();
}

class _SharingViewEventsState extends State<SharingViewEvents> {

  List<Event> _userEvents = [];
  bool _isEventsLoaded = true;

  @override
  void initState() {
    super.initState();
    fetchUserEvents();
  }

  Future<void> fetchUserEvents() async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isEventsLoaded = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('events')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _userEvents = querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isEventsLoaded = false));

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
                'https://i.pinimg.com/564x/12/ad/fa/12adfa1035792c44248d3eab35212c91.jpg',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Etkinliklerim',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
    body:SafeArea(
    child: Column(
    children: [
      Expanded(
        child: _isEventsLoaded
            ? Center(child: CircularProgressIndicator())
            : _userEvents.isEmpty
            ? Center(child: Text("Etkinlik bulunamadı."))
            : ListView.builder(
          itemCount: _userEvents.length,
          itemBuilder: (context, index) {
            return buildEventCard(_userEvents[index]);
          },
        ),
      ),
    ],
    ),
    ),
    );
  }
}
