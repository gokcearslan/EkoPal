import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/answer_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'display_answers_page.dart';


class CreateAnswerPage extends StatefulWidget {
  final SoruCevap question;

  CreateAnswerPage({required this.question});

  @override
  _CreateAnswerPageState createState() => _CreateAnswerPageState();
}

class _CreateAnswerPageState extends State<CreateAnswerPage> {
  final TextEditingController _answerController = TextEditingController();
  final SoruCevapService _questionService = SoruCevapService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitAnswer() async {
    if (_formKey.currentState!.validate()) {

      String? userId = UserManager().userId;
      String? userName = await UserManager().getUserName();

      if ( userName == null) {
        print('User not logged in');
        return;
      }

      Answer answer = Answer(
        answer: _answerController.text,
        createdBy: userName,
        timestamp: DateTime.now(), // Add current timestamp
      );

      String? questionId = await _questionService.findQuestionId(
        widget.question.soru,
        widget.question.soruDetails,
        widget.question.createdBy,
      );

      if (questionId != null) {
        // Adding the answer to the question's subcollection
        await _questionService.addAnswer(questionId, answer).then((value) {
          print("Yanıt başarıyla eklendi");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yanıt başarıyla eklendi")));

          //Navigator.of(context).pop();
          _answerController.clear();
          //display comments sayfasına git
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionDetailsPage(question: widget.question)),
          );

        }).catchError((error) {
          print("Yanıt ekleme sırasında bir hata oluştu: $error");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yanıt ekleme sırasında bir hata oluştu')));
        });
      } else {
        print('Soru bulunamadı');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Soru bulunamadı')));
      }
    }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('           Yanıt Gönder'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appBarColor,
        actions: [
          TextButton.icon(
            onPressed: _submitAnswer,
            icon: Icon(Icons.question_answer_outlined, color: Colors.black),
            label: Text(
              '',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/7980/7980078.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${widget.question.createdBy}',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Text(' adlı kişiye yanıt olarak'),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  hintText: 'Bir cevap yazarak yardım edin!',
                  border: InputBorder.none,
                ),
                maxLines: null,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yanıt boş bırakılamaz';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
