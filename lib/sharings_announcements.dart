import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class SharingViewAnnouncements extends StatefulWidget {
  @override
  _SharingViewAnnouncementsState createState() => _SharingViewAnnouncementsState();
}

class _SharingViewAnnouncementsState extends State<SharingViewAnnouncements> {

  List<Duyuru> _userAnnouncements = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUserAnnouncements();
  }


  Future<void> fetchUserAnnouncements() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('duyurular')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _userAnnouncements = querySnapshot.docs.map((doc) => Duyuru.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isLoading = false));
  }

  Widget buildAnnouncementCard(Duyuru duyuru) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    String imageUrl = 'https://seeklogo.com/images/I/Izmir_Ekonomi_Universitesi-logo-1DBBF2BAF5-seeklogo.com.png';
    String duyuruName = duyuru.duyuruName ?? 'Unnamed Announcement';
    String duyuruDetails = duyuru.duyuruDetails ?? 'No details provided.';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Duyurularım',
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
        child: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _userAnnouncements.isEmpty
    ? Center(child: Text("Duyuru bulunamadı."))
        : ListView.builder(
    itemCount: _userAnnouncements.length,
    itemBuilder: (context, index) {
    Duyuru announcement = _userAnnouncements[index];
    return  buildAnnouncementCard(_userAnnouncements[index]);
    },
    ),
    ),
            ],
        ),
        ),
    );
  }
}
