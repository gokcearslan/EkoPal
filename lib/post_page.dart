import 'dart:async';
import 'package:ekopal/postCard.dart';
import 'package:ekopal/post_create_page.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/firebase_service.dart';

import 'colors.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post>? posts;
  PostService _postService = PostService();
  StreamSubscription<List<Post>>? postsSubscription;

  @override
  void initState() {
    super.initState();
    postsSubscription = _postService.getPostsStream().listen(
            (updatedPosts) {
          if (mounted) {
            setState(() {
              posts = updatedPosts;
            });
          }
        },
        onError: (error) {
          print("Error fetching posts stream: $error");
        }
    );
  }

  @override
  void dispose() {
    postsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gönderiler',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: posts == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: posts!.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts![index]);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PostCreationPage()),
          );
        },
        backgroundColor: lightButtonColor,
        child: const Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
