import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/SoruCevapCard.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class SharingViewQuestions extends StatefulWidget {
  @override
  _SharingViewQuestionsState createState() => _SharingViewQuestionsState();
}

class _SharingViewQuestionsState extends State<SharingViewQuestions> {
  List<SoruCevap>? UserQuestions;
  bool _isLoaded=true;


  @override
  void initState() {
    super.initState();
    fetchUserQuestions();
  }

  Future<void> fetchUserQuestions() async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoaded = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('soru_cevap')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      UserQuestions = querySnapshot.docs.map((doc) => SoruCevap.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isLoaded = false));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sorularım',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body:SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoaded
                  ? Center(child: CircularProgressIndicator())
                  : UserQuestions == null || UserQuestions!.isEmpty
                  ? Center(child: Text("Soru bulunamadı."))
                  : ListView.builder(
                itemCount: UserQuestions!.length,
                itemBuilder: (context, index) {
                  return SoruCevapCard(soruCevap: UserQuestions![index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
