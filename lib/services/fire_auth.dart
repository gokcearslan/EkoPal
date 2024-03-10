import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user =
          userCredential.user;
      await user!.updateProfile(
          displayName: name);
      await user.reload();
      user = auth.currentUser;


      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
       // 'formcount': 0,
        'base64Image': "",
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Zayıf Şifre');
      } else if (e.code == 'email-already-in-use') {
        print('Bu mail zaten kullanılıyor');
      }
    }catch(e){
      print(e);
    }
    return user;
  }
/////// Buraya bakilmasi lazim
  static Future<User?>signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Böyle bir kullanıcı bulunmamaktadır');
      } else if (e.code == 'wrong-password') {
        print('Yanlış Şifre!');
      }
    }catch(e){
      print(e);
    }
    return user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }
}
