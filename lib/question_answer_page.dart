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

  @override
  void initState() {
    super.initState();
    fetchSoruCevap();
  }

  void fetchSoruCevap() async {
    soruCeap = await _soruCevapService.getSoruCevap();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,

        backgroundColor: appBarColor,

        title: const Text('Sor ya da Cevapla',
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
