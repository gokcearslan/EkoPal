import 'package:ekopal/post_create_page.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/post_model.dart'; // Assuming this exists and is similar to event_model.dart
import 'package:ekopal/services/firebase_service.dart'; // Assuming this includes PostService

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
    posts = await PostService().getPosts(); // Assuming getPosts exists and works similarly to getEvents
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        // Adjust the colors as needed
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PostCreationPage()),
          );
        },
        child: Icon(Icons.add),
        // Adjust the colors and icons as needed
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
              post.PostContent, // Assuming PostContent is what you want to display
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // Include other post details here (e.g., author, timestamp) if available
          ],
        ),
      ),
    );
  }
}
