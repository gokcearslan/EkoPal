import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/voting_service.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/post_model.dart';

class deletePostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onDelete;

  deletePostCard({Key? key, required this.post, required this.onDelete}) : super(key: key);

  @override
  _deletePostCardState createState() => _deletePostCardState();
}

class _deletePostCardState extends State<deletePostCard> {
  final VoteManager _voteManager = VoteManager();
  final PostService _postService = PostService();
  late int upvotes;
  late int downvotes;
  late Color upvoteColor;
  late Color downvoteColor;
  late Map<String, String> votedUsers;
  String? userId;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    userId = UserManager().userId;
    _loadProfilePicture();
    upvotes = widget.post.upvotes;
    downvotes = widget.post.downvotes;
    votedUsers = widget.post.votedUsers;
    updateVoteColors();
  }

  Future<void> _loadProfilePicture() async {
    String? url = await UserManager().getProfilePictureUrl(widget.post.userId);
    setState(() {
      imageUrl = url;
    });
  }

  void updateVoteColors() {
    if (userId != null && votedUsers[userId!] == 'up') {
      upvoteColor = Colors.blue;
      downvoteColor = Colors.grey;
    } else if (userId != null && votedUsers[userId!] == 'down') {
      upvoteColor = Colors.grey;
      downvoteColor = Colors.red;
    } else {
      upvoteColor = Colors.grey;
      downvoteColor = Colors.grey;
    }
  }

  Future<void> handleVote(bool isUpvote) async {
    if (userId == null) {
      print("User ID is null, cannot vote");
      return print("User not found");
    }
    print("vote id is: " + widget.post.id);
    String? documentIDinFB = await findDocumentByCustomId(widget.post.id);
    _voteManager.vote(documentIDinFB!, isUpvote).then((_) {
      setState(() {
        if (isUpvote) {
          if (votedUsers[userId!] == 'up') {
            upvotes--;
            votedUsers.remove(userId);
          } else {
            upvotes++;
            if (votedUsers[userId!] == 'down') {
              downvotes--;
            }
            votedUsers[userId!] = 'up';
          }
        } else {
          if (votedUsers[userId!] == 'down') {
            downvotes--;
            votedUsers.remove(userId);
          } else {
            downvotes++;
            if (votedUsers[userId!] == 'up') {
              upvotes--;
            }
            votedUsers[userId!] = 'down';
          }
        }
        updateVoteColors();
      });
    }).catchError((error) {
      print("Error handling vote: $error");
    });
  }

  Future<String?> findDocumentByCustomId(String sid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore.collection('posts').where('id', isEqualTo: sid).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        print('Firebase Document ID: $docId');
        return docId;
      } else {
        print('No document found with custom ID $sid');
        return null;
      }
    } catch (e) {
      print('Error finding document by ID: $e');
      return null;
    }
  }

  Future<void> _deletePost() async {
    String? documentIDinFB = await findDocumentByCustomId(widget.post.id);
    if (documentIDinFB != null) {
      await _postService.deletePost(documentIDinFB).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gönderi başarıyla silindi")));
        widget.onDelete();
      }).catchError((error) {
        print("Silme sırasında bir hata oluştu: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Silme sırasında bir hata oluştu')));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    String formattedDate = "2 days ago";
    const String defaultImageUrl = 'https://cdn-icons-png.flaticon.com/256/12989/12989000.png';

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : NetworkImage(defaultImageUrl),
            ),
            title: Text(widget.post.createdBy, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(formattedDate),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.deepPurple),
              onPressed: _deletePost,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              'https://cdn.vectorstock.com/i/500p/28/89/a-question-mark-symbol-vector-1122889.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.postTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(widget.post.PostContent),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up, color: upvoteColor),
                onPressed: () => handleVote(true),
              ),
              Text('$upvotes'),
              IconButton(
                icon: Icon(Icons.thumb_down, color: downvoteColor),
                onPressed: () => handleVote(false),
              ),
              Text('$downvotes'),
            ],
          ),
        ],
      ),
    );
  }
}
