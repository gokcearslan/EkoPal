import 'package:flutter/material.dart';

class AnnouncementsPage extends StatelessWidget {
  final List<String> announcements = [
    "Announcement 1: Welcome to our new app!",
    "Announcement 2: New features coming soon.",
    "Announcement 3: Scheduled maintenance on Sunday.",
    // Add more announcements here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(announcements[index]),
              leading: Icon(Icons.announcement),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle the tap if needed, for example, to show more details
              },
            ),
          );
        },
      ),
    );
  }
}