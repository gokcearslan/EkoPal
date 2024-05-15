import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal();

  String? userId;

  Future<void> login(String id) async {
    userId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }

  Future<void> logout() async {
    userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  Future<String?> getProfilePictureUrl(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['imageUrl'];
  }

  Future<String?> getUserName() async {
    if (userId == null) {
      return null;
    }
    DocumentSnapshot userProfile = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userProfile['name'];
  }


  Future<String?> getUserRole() async {
    if (userId == null) {
      await loadUserId();
      if (userId == null) {
        return null;
      }
    }
    DocumentSnapshot userProfile = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userProfile['role'];
  }
}
