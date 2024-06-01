import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ekopal/postCard.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/colors.dart';

class UserVotesPage extends StatefulWidget {
  @override
  _UserVotesPageState createState() => _UserVotesPageState();
}

class _UserVotesPageState extends State<UserVotesPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  List<Post> userVotedPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserVotes();
  }

  void fetchUserVotes() async {
    if (userId == null) {
      print("No user logged in");
      return;
    }

    QuerySnapshot snapshot = await _db.collection('posts')
        .where('votedUsers', isNotEqualTo: {})
        .get();

    List<Post> posts = snapshot.docs.map((doc) {
      return Post.fromFirestore(doc);
    }).where((post) => post.votedUsers.containsKey(userId)).toList();

    if (mounted) {
      setState(() {
        userVotedPosts = posts;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: ListView.builder(
        itemCount: userVotedPosts.length,
        itemBuilder: (context, index) {
          Post post = userVotedPosts[index];
          return PostCard(post: post);
        },
      ),
    );
  }
}
