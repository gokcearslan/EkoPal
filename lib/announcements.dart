import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'announcementsDetails_page.dart'; // Make sure this import points to the correct file

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
    // A function to shorten the details text and add "..." if it's too long
    String shortenDetails(String details) {
      const int maxLength = 50; // Maximum number of characters to display
      if (details.length > maxLength) {
        return details.substring(0, maxLength) + '...';
      } else {
        return details;
      }
    }

    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(data['duyuruName']),
        subtitle: Text(shortenDetails(data['duyuruDetails'])), // Show a part of the details
        leading: Icon(Icons.announcement, color: Theme.of(context).colorScheme.secondary),
        trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurface),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AnnouncementDetailsPage(data: data),
          ));
        },
      ),
    );
  }
}
