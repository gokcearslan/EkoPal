import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySharingsPage extends StatefulWidget {
  @override
  _MySharingsPageState createState() => _MySharingsPageState();
}

class _MySharingsPageState extends State<MySharingsPage> {
  List<Duyuru> _userPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  Future<void> fetchUserPosts() async {
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
      _userPosts = querySnapshot.docs.map((doc) => Duyuru.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posts"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userPosts.isEmpty
          ? Center(child: Text("No posts found."))
          : ListView.builder(
        itemCount: _userPosts.length,
        itemBuilder: (context, index) {
          Duyuru post = _userPosts[index];
          return ListTile(
            title: Text(post.duyuruName),
            subtitle: Text(post.duyuruDetails),
          );
        },
      ),
    );
  }
}

