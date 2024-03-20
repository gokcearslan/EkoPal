import 'package:ekopal/advertisements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/login_page.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/profile_page.dart';
import 'announcements.dart';
import 'create_page.dart';
import 'events_page.dart';

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

  //Appbar ve Bottombar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          title: Text(
            'EkoPal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 40,
            ),
          ),
          centerTitle: true,
          backgroundColor: kahve,
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
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: kahve,
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
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => FancyPage()));
                  // Add navigation logic here
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
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _HomePageState().signOutAndNavigateToLogin();
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
        ],
      ),
    );
  }
}

