
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  PostService _postService = PostService();

  void _upvote() async {
    int originalUpvotes = widget.post.upvotes;
    try {
      // Update votes in Firestore
      await _postService.upvotePost(widget.post.id);
      // Update UI after successful update
      setState(() {
        widget.post.upvotes += 1; // Optimistically update UI
      });
    } catch (error) {
      // Revert UI changes if an error occurs
      setState(() {
        widget.post.upvotes = originalUpvotes;
      });
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upvote: $error')),
      );
    }
  }

  void _downvote() async {
    int originalDownvotes = widget.post.downvotes;
    setState(() {
      widget.post.downvotes += 1; // Optimistically update UI
    });
    try {
      await _postService.downvotePost(widget.post.id);
    } catch (error) {
      setState(() {
        widget.post.downvotes = originalDownvotes; // Revert if error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to downvote: $error')),
      );
    }
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
