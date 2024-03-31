import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'announcementsDetails_page.dart'; //

class AnnouncementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duyurular"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('duyurular').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                  if (data == null) {
                    return Center(child: Text('Document data is null'));
                  }
                  return AnnouncementCard(data: data);
                },
              );
          }
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
    final ThemeData theme = Theme.of(context);

    String imageUrl = data['imageUrl'] as String? ?? 'https://seeklogo.com/images/I/Izmir_Ekonomi_Universitesi-logo-1DBBF2BAF5-seeklogo.com.png';
    String duyuruName = data['duyuruName'] as String? ?? 'Unnamed Announcement';
    String duyuruDetails = data['duyuruDetails'] as String? ?? 'No details provided.';

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Theme( //
        data: theme.copyWith(dividerColor: Colors.transparent), //
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(16.0), //
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            duyuruName,
            style: theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(duyuruDetails, style: theme.textTheme.bodyText2),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            if (expanded) {
              //
            } else {
              //
            }
          },
        ),
      ),
    );
  }
}
