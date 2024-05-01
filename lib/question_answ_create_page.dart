import 'package:ekopal/colors.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//yeni soru sorma ekranı UI - 1 mayıs bilge

class AskQuestionPage extends StatefulWidget {
  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  TextEditingController _soruController = TextEditingController();
  TextEditingController _soruDetailsController = TextEditingController();

  void _submitQuestion() {
    Navigator.of(context).pop();  // To close the screen after submitting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:buttonColor,

        title: Text('Sorun varsa, Gönder!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _soruController,
              decoration: InputDecoration(
                labelText: 'Soru Başlığı',
                hintText: 'Soruyu özetleyen bir başlık seçin.',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!)),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _soruDetailsController,
              decoration: InputDecoration(
                labelText: 'Soru İçeriği',
                hintText: 'Sorunuzdan kısaca bahsedin.',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!), // Lighter border color
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              textInputAction: TextInputAction.newline,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // makes the button stretch to full width
              child: ElevatedButton(
                onPressed: () async {

                  String? userId = FirebaseAuth.instance.currentUser?.uid;

                  if (userId == null) {
                    print('No user logged in');
                    return;
                  }

                  SoruCevap soruCevap = SoruCevap(
                    soru: _soruController.text,
                    soruDetails: _soruDetailsController.text,
                    userId: userId,
                  );
                  SoruCevapService().addSoruCevap(soruCevap);
                  _soruController.clear();
                  _submitQuestion();
                },

                child: Text('Sorum var!',style: TextStyle(
                  color: Colors.black,),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: cardColor, // button background color

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
