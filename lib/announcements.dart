import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'announcementsDetails_page.dart'; // Ensure this import points to the correct file

class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('duyurular').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return AnnouncementCard(data: data);
            }).toList(),
          );
        },
      ),
    );
  }
}


class AnnouncementCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AnnouncementCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String shortenDetails(String details) {
      const int maxLength = 100; // Adjusted maximum length to show more preview text
      return (details.length > maxLength) ? details.substring(0, maxLength) + '...' : details;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8.0, // Enhanced elevation for a more pronounced shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)), // Rounded corners for a modern look
        child: InkWell( // InkWell for a nice tap effect
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AnnouncementDetailsPage(data: data),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['duyuruName'],
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  shortenDetails(data['duyuruDetails']),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
