import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'announcementsDetails_page.dart';
import 'colors.dart';
import 'create_page.dart';

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

      if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
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
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          "Duyurular",
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
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
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                if (data == null) {
                  return Center(child: Text('Document data is null'));
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementDetailsPage(data: data),
                      ),
                    );
                  },
                  child: AnnouncementCard(data: data),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: userRole == 'staff'
          ? FloatingActionButton(
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
        backgroundColor: lightButtonColor,
      )
          : null,
    );
  }
}

class AnnouncementCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const AnnouncementCard({Key? key, required this.data}) : super(key: key);

  @override
  _AnnouncementCardState createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  String? userName;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    String userId = widget.data['userId'];
    Map<String, String?> userInfo = await fetchUserInfo(userId);
    setState(() {
      userName = userInfo['name'];
      userEmail = userInfo['email'];
      isLoading = false;
    });
  }

  Future<Map<String, String?>> fetchUserInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return {
          'name': userDoc['name'],
          'email': userDoc['email'],
        };
      } else {
        return {
          'name': null,
          'email': null,
        };
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return {
        'name': null,
        'email': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    String imageUrl = widget.data['imageUrl'] as String? ?? 'https://files.sikayetvar.com/lg/cmp/93/9386.png?1522650125';
    String duyuruName = widget.data['duyuruName'] as String? ?? 'Unnamed Announcement';
    String duyuruDetails = widget.data['duyuruDetails'] as String? ?? 'No details provided.';

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 5.0,
      color: cardColor,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(duyuruDetails, style: theme.textTheme.bodyText2),
            ),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 24, color:duyuruKoyuIcon),
                    SizedBox(width: 8),
                Text(
                  'Oluşturan: ${userName ?? 'Bilinmiyor'}',
                  style: theme.textTheme.bodyText2?.copyWith(
                  ),
                ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.email, size: 24, color: duyuruKoyuIcon),
                    SizedBox(width: 8),
                    Text(
                      'İletişim: ${userEmail ?? 'Bilinmiyor'}',
                      style: theme.textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
