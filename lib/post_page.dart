import 'package:ekopal/postCard.dart';
import 'package:ekopal/post_create_page.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/firebase_service.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post>? posts;
  PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    posts = await _postService.getPosts();
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gönderiler'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: posts == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts!.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts![index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostCreationPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
