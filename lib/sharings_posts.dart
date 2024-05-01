import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/postCard.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SharingViewPosts extends StatefulWidget {
  @override
  _SharingViewPostsState createState() => _SharingViewPostsState();
}

class _SharingViewPostsState extends State<SharingViewPosts> {

  List<Post>? UserPosts;
  bool _isLoaded=true;

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }
  Future<void> fetchUserPosts() async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoaded = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      UserPosts = querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isLoaded = false));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gönderilerim'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoaded
                ? Center(child: CircularProgressIndicator())
                : UserPosts == null || UserPosts!.isEmpty
                ? Center(child: Text("Gönderi bulunamadı."))
                : ListView.builder(
              itemCount: UserPosts!.length,
              itemBuilder: (context, index) {
                return PostCard(post: UserPosts![index]);
              },
            ),
          ),
        ],
      ),
    );

  }








}
