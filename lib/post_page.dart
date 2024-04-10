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

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Your specified image URL
    String imageUrl = 'https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg';

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            post.postTitle,
            style: theme.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                post.PostContent,
                style: theme.textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
