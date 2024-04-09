import 'package:flutter/material.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/post_create_page.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post>? posts;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  fetchPosts() async {
    posts = await PostService().getPosts();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: posts == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts!.length,
        itemBuilder: (context, index) {
          return buildPostCard(posts![index]);
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

  Widget buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.postTitle, // Display the title
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10), // Space between title and content
            Text(
              post.PostContent, // Display the content
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
