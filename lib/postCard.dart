import 'package:ekopal/colors.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure this import is present if you're using it for date formatting

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int upvotes = 0;
  int downvotes = 0;
  Color upvoteColor = Colors.grey;
  Color downvoteColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    upvotes = widget.post.upvotes;
    downvotes = widget.post.downvotes;
  }

  void incrementUpvote() {
    setState(() {
      upvotes++;
      upvoteColor = Colors.blue;
      downvoteColor = Colors.grey;
    });
  }

  void incrementDownvote() {
    setState(() {
      downvotes++;
      downvoteColor = Colors.red;
      upvoteColor = Colors.grey;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "2 days ago"; // This should be dynamically generated based on your data

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage( 'https://via.placeholder.com/150'),
            ),
            title: Text('Default User', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(formattedDate),
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              ('https://cdn.vectorstock.com/i/500p/28/89/a-question-mark-symbol-vector-1122889.jpg'),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.postTitle ?? "No title",
              style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(widget.post.PostContent ?? "No content"),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up, color: upvoteColor),
                onPressed: incrementUpvote,
              ),
              Text('$upvotes'),
              IconButton(
                icon: Icon(Icons.thumb_down, color: downvoteColor),
                onPressed: incrementDownvote,
              ),
              Text('$downvotes'),

            ],
          ),
        ],
      ),
    );
  }
}