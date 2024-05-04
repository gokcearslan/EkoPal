import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoteManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // Method to upvote or downvote a post

  Future<void> vote(String postId, bool isUpvote) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference postRef = _db.collection('posts').doc(postId);
    print("post id in voting service getting : " + postId);

    try {
      await _db.runTransaction((transaction) async {
        print("Checking document at path: ${postRef
            .path}");
        DocumentSnapshot snapshot = await transaction.get(postRef);

        if (!snapshot.exists) {
          print("Document with ID $postId does not exist.");
          throw Exception("Post does not exist!");
        }

        int upvotes = snapshot['upvotes'];
        int downvotes = snapshot['downvotes'];
        Map votedUsers = snapshot['votedUsers'] ?? {};

        String? previousVote = votedUsers[userId];

        if (previousVote == 'up' && isUpvote) {
          // User is removing upvote
          upvotes--;
          votedUsers.remove(userId);
        } else if (previousVote == 'down' && !isUpvote) {
          // User is removing downvote
          downvotes--;
          votedUsers.remove(userId);
        } else {
          if (previousVote == 'up') {
            upvotes--;
          } else if (previousVote == 'down') {
            downvotes--;
          }

          // Apply new vote
          if (isUpvote) {
            upvotes++;
            votedUsers[userId] = 'up';
          } else {
            downvotes++;
            votedUsers[userId] = 'down';
          }
        }

        transaction.update(postRef, {
          'upvotes': upvotes,
          'downvotes': downvotes,
          'votedUsers': votedUsers
        });
      });
    } catch (e) {
      print("Error during voting transaction: $e");
      throw Exception("Failed to process vote: $e");
    }
  }
}
