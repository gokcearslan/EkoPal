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

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  PostService _postService = PostService();

  void _upvote() {
    int originalUpvotes = widget.post.upvotes;
    setState(() {
      widget.post.upvotes += 1; // Optimistically update UI
    });
    _postService.upvotePost(widget.post.id).catchError((error) {
      setState(() {
        widget.post.upvotes = originalUpvotes; // Revert if error
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upvote: $error'))
      );
    });
  }

  void _downvote() {
    int originalDownvotes = widget.post.downvotes;
    setState(() {
      widget.post.downvotes += 1; // Optimistically update UI
    });
    _postService.downvotePost(widget.post.id).catchError((error) {
      setState(() {
        widget.post.downvotes = originalDownvotes; // Revert if error
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to downvote: $error'))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          widget.post.postTitle,
          style: theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.PostContent,
              style: theme.textTheme.bodyText2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up, color: Colors.green),
                onPressed: _upvote,
              ),
              Text('${widget.post.upvotes}'),
              IconButton(
                icon: Icon(Icons.thumb_down, color: Colors.red),
                onPressed: _downvote,
              ),
              Text('${widget.post.downvotes}'),
            ],
          ),
        ],
      ),
    );
  }
}