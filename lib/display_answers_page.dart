import 'package:ekopal/services/answer_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';

import 'SoruCevapCard.dart';
import 'answerCard.dart';
import 'answer_toquestion_page.dart';
import 'colors.dart';
import 'displayAllAnswersCard.dart';


class QuestionDetailsPage extends StatefulWidget {
  final SoruCevap question;

  QuestionDetailsPage({required this.question});

  @override
  _QuestionDetailsPageState createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  final SoruCevapService _questionService = SoruCevapService();
  String? questionId;

  @override
  void initState() {
    super.initState();
    _fetchQuestionId();
  }

  Future<void> _fetchQuestionId() async {
    String? id = await _questionService.findQuestionId(
      widget.question.soru,
      widget.question.soruDetails,
      widget.question.createdBy,
    );
    setState(() {
      questionId = id;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('            Soru Detayları'),
        backgroundColor: appBarColor,

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                displayAllAnswersCard(soruCevap: widget.question),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Yanıtlar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<List<Answer>>(
                  stream: _questionService.getAnswers(questionId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<Answer> answers = snapshot.data!;
                    return Column(
                      children: answers.map((answer) => AnswerCard(answer: answer)).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
