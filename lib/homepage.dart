import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/EkoBotPage.dart';
import 'package:ekopal/login_page.dart';
import 'package:ekopal/postCard.dart';
import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/user_provider.dart';
import 'package:ekopal/sharings_advertisement.dart';
import 'package:ekopal/sharings_announcements.dart';
import 'package:ekopal/sharings_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/profile_page.dart';
import 'package:ekopal/post_page.dart';
import 'package:ekopal/question_answer_page.dart';
import 'package:ekopal/main.dart';
import 'package:ekopal/create_page.dart';
import 'package:ekopal/events_page.dart';
import 'package:ekopal/announcements.dart';
import 'package:ekopal/onboarding_view.dart';

import 'mySharingsPage.dart';

class HomePage extends StatefulWidget {
  final String? base64Image; // Define base64Image as a parameter

  const HomePage({Key? key, this.base64Image}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _profileImageUrl;

  late String userName = "";
  late String userEmail = "";
  int _selectedIndex = 0;
  bool _isProfileExpanded = false;
  bool _isSigningOut = false;

  final UserProvider _userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    fetchUser();
    _fetchProfileImage();

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
  Future<void> _fetchProfileImage() async {
    String? imageUrl = await _userProvider.getUserProfileImage();
    setState(() {
      _profileImageUrl = imageUrl;
    });
  }

  void _toggleProfileExpansion() {
    setState(() {
      _isProfileExpanded = !_isProfileExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          title: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainApp()));
            },
            child: Text(
              'EkoPal',
              style: TextStyle(
                color: Colors.black,
               fontWeight: FontWeight.normal,
                fontSize: 55,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: appBarColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: textColor),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EkoBotPage()));
                },
                child: Container(
                  width: 80,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://i.pinimg.com/736x/48/46/2e/48462eb8ccb2d4463d2e31499abe10b7.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _selectedIndex == 0 ? HomePageContent(base64Image: widget.base64Image, userName: userName) : ProfilePage(),
          /*
          Positioned(
            top: 3,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Navigation logic to EkoBot page
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EkoBotPage()));
              },
              child: Container(
               width: 80,  // Standard FAB size
               height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://i.pinimg.com/736x/48/46/2e/48462eb8ccb2d4463d2e31499abe10b7.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              backgroundColor: Colors.grey, // Make the button blend with the icon
            ),
          ),
    */
        ],
      ),
      drawer: Drawer(

          child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Column(
                  children: [
                    SafeArea(
                      child: Container(
                        color: appBarColor,
                        padding: EdgeInsets.all(16.0),
                        child: ExpansionTile(
                          title: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProfilePage()),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 172,
                                    height: 180,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: _profileImageUrl != null
                                          ? Image.network(
                                        _profileImageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                          : Placeholder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProfilePage()),
                                    );
                                  },
                                  child: Text(
                                    userName,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  userEmail,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                ListTile(
                  title: Text('Paylaşımlarım'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MySharingsPage()));
                  },
                ),
                ListTile(
                  title: Text('Gönderiler'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostsPage()));
                  },
                ),
                ListTile(
                  title: Text('Soru-Cevap'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayQuestionsPage()));

                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the button horizontally
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await FirebaseAuth.instance.signOut();
                        await UserManager().logout();
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => OnboardingPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Çıkış',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.exit_to_app, color: Colors.white, size: 16),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                        ),
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjusted border radius for a smaller button
                        ),
                        minimumSize: Size(280, 20),
                      ),
                    ),
                  ],
                )
              ],
              ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePage()));
        },
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
        ),
        backgroundColor: lightButtonColor,
      ),

    );
  }
}

class HomePageContent extends StatefulWidget {
  final String? base64Image;
  final String userName;

  const HomePageContent({Key? key, required this.base64Image, required this.userName}) : super(key: key);

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
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('duyurular').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
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
          if (announcementData != null)
            AnnouncementCard(data: announcementData!),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popüler Gönderiler',
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
          StreamBuilder<List<Post>>(
            stream: fetchTopUpvotedPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No posts found");
              }

              return ListView.builder(
                shrinkWrap: true, // Important to ensure no conflicts within Column
                physics: NeverScrollableScrollPhysics(), // to disable scrolling within the list
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PostCard(
                      key: ValueKey(snapshot.data![index].id),
                      post: snapshot.data![index]
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<List<Post>> fetchTopUpvotedPostsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('upvotes', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }



}
