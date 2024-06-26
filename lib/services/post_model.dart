import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String PostContent;
  final String postTitle;
  int upvotes;
  int downvotes;
  final String userId;
  Map<String, String> votedUsers;
  final String createdBy;
  final String? imageUrl;

  Post({
    required this.id,
    required this.PostContent,
    required this.postTitle,
    this.upvotes = 0,
    this.downvotes = 0,
    required this.userId,
    this.votedUsers = const {},
    required this.createdBy,
    this.imageUrl,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: data['id'],
      PostContent: data['PostContent'],
      postTitle: data['postTitle'],
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      userId: data['userId'],
      createdBy: data['createdBy'],
      votedUsers: Map<String, String>.from(data['votedUsers'] ?? {}),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'PostContent': PostContent,
      'postTitle': postTitle,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'userId': userId,
      'createdBy': createdBy,
      'votedUsers': votedUsers,
      'imageUrl': imageUrl,
    };
  }
}