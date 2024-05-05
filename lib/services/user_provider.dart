import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider {
  Future<String?> getUserProfileImage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      return data?['imageUrl'];
    }
    return null;
  }

  Future<String?> getUserName() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      return data?['name'];
    }
    return null;
  }
}
