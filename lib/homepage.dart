import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/advertisements.dart';
import 'package:ekopal/advertisements_view_page.dart';
import 'package:ekopal/post_create_page.dart';
import 'package:ekopal/post_page.dart';
import 'package:ekopal/question_answer_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/login_page.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/profile_page.dart';
import 'announcements.dart';
import 'create_page.dart';
import 'events_page.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userName = "";
  late String userEmail = "";
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userName = user.displayName ?? "";
          userEmail = user.email ?? "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void signOutAndNavigateToLogin() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          title: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainApp()));
            },
            child: Text(
              'EkoPal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 40,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
          // Modify the drawer icon color here
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white), // Set your desired color here
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),

      drawer: Container(
        color: Colors.white, // Set the background color of the container
        //yandaki menü
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Text(
                  'Kategoriler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('İlanlar'),
                onTap: () {
                  Navigator.pop(context);  // used to go to main page instead of drawer(hamburger)
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAdvertisements()));
                },
              ),
              ListTile(
                title: Text('Duyurular'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => AnnouncementsPage()));
                },
              ),
              ListTile(
                title: Text('Etkinlikler'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => EventsPage()));
                  // Add navigation logic here
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text('Oluştur'),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => CreatePage()));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text('Post Oluştur'),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => PostCreationPage()));
                },
              ),
            ],
          ),
        ),
      ),

      //Create butonu floating
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePage()));
        },
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: koyuSomon,
          ),
        ),
        backgroundColor: floatingcolor,
       // backgroundColor: Colors.transparent, // transparent olunca gözükmüyor gibi geldi
       // elevation: 0, // Remove shadow

      ),

    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  Map<String, dynamic>? announcementData;

  @override
  void initState() {
    super.initState();
    fetchAnnouncement();
  }

  void fetchAnnouncement() async {
    // Fetch a single announcement from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('duyurular').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        // Assuming your data structure has fields 'imageUrl', 'duyuruName', and 'duyuruDetails'
        announcementData = snapshot.docs.first.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              });
            },
            child: Text('Çıkış'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Text('Profil'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostsPage()),
              );
            },
            child: Text('Post'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SoruCevapDisplayPage()),
              );
            },
            child: Text('Soru-Cevap'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Duyurular',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            height: 2.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.orange, Colors.brown],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          // Display the announcement card if data is available
          if (announcementData != null)
            AnnouncementCard(data: announcementData!),
          // You might want to add some more content here or handle the case when data is not available
        ],
      ),
    );
  }
}


