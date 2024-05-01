import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String PostContent;
  final String postTitle;
  int upvotes;
  int downvotes;
  final String userId;

  Post({
    required this.id,
    required this.PostContent,
    required this.postTitle,
     this.upvotes=0,
     this.downvotes=0,
    required this.userId,

  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: data['id'],
      PostContent: data['PostContent'],
      postTitle: data['postTitle'],
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      userId: data['userId'],
    );
  }
}
