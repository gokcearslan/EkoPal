import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'announcementsDetails_page.dart';
import 'colors.dart';
import 'create_page.dart'; //

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {

  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Check if the snapshot exists and contains data
      if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
        // Cast the data to a Map and then access the 'role'
        Map<String, dynamic> userData = userDocSnapshot.data()! as Map<String, dynamic>;
        setState(() {
          userRole = userData['role'] as String?;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:white,
      appBar: AppBar(
        title: const Text("Duyurular",
            style: TextStyle(
              fontSize: 30,
            ),
        ),
        backgroundColor: appBarColor,
        actions: <Widget>[
          /*
          IconButton(
            icon: Icon(Icons.edit), // The edit/pencil icon
            onPressed: () {
              // Edit fonksiyon
              print('Edit icon tapped');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              // delete fonksiyonu
              print('Trash icon tapped');
            },
          ),

           */
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('duyurular').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>;
              if (data == null) {
                return Center(child: Text('Document data is null'));
              }
              return AnnouncementCard(data: data); //
            },
          );
        },
      ),

      //Create butonu floating

    floatingActionButton: userRole == 'staff' ? FloatingActionButton(
    onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CreatePage(initialCategory: 'Duyuru')));
    },
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
        ),
        backgroundColor: floatingcolor,
    ) : null,
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
      color:cardColor,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(16.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust this for alignment
            children: [
              Flexible(
                child: Text(
                  duyuruName,
                  style: theme.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),

              IconButton(
                icon: Icon(Icons.edit, color: theme.colorScheme.secondary),
                onPressed: () {
                  // Placeholder for future edit functionality
                  print('Edit button tapped');
                },
              ),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(duyuruDetails, style: theme.textTheme.bodyText2),
            ),
          ],
        ),
      ),
    );
  }
}
