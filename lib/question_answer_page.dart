import 'dart:async';
import 'package:ekopal/question_answ_create_page.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'SoruCevapCard.dart';
import 'colors.dart';

class DisplayQuestionsPage extends StatefulWidget {
  @override
  _DisplayQuestionsPageState createState() => _DisplayQuestionsPageState();
}

class _DisplayQuestionsPageState extends State<DisplayQuestionsPage> {
  List<SoruCevap>? soruCeap;
  SoruCevapService _soruCevapService = SoruCevapService();
  StreamSubscription<List<SoruCevap>>? soruCeapSubscription;

  @override
  void initState() {
    super.initState();
    soruCeapSubscription = _soruCevapService.getSoruCevapStream().listen(
            (updatedSoruCevap) {
          if (mounted) {
            setState(() {
              soruCeap = updatedSoruCevap;
            });
          }
        },
        onError: (error) {
          print("Error fetching soru cevap stream: $error");
        }
    );
  }

  @override
  void dispose() {
    soruCeapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text('Sor ve Cevapla',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: soruCeap?.length ?? 0,
            itemBuilder: (context, index) {
              return SoruCevapCard(soruCevap: soruCeap![index]);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AskQuestionPage()),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
        ),
        backgroundColor: lightButtonColor,
      ),
    );
  }
}
