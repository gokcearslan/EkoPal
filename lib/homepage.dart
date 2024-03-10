import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/login_page.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/profile_page.dart'; // Import the profile page

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
        preferredSize: Size.fromHeight(45), //appbar'ın kapladığı alan
        child: AppBar(
          title: Text(
            'EkoPal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400, //  Appbar yazı kalınlığı
              fontSize: 40,
            ),
          ),
          centerTitle: true,
          backgroundColor: kahve,
        ),
      ),
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
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
              _HomePageState().signOutAndNavigateToLogin(); // Calling the sign out method from the state class
            },
            child: Text('Çıkış'),
          ),
        ],
      ),
    );
  }
}
