import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/question_answ_create_page.dart';

//SORU CEVAP GÖKÇE UI SAYFASI !!!
//görüntüleme

class SoruCevapDisplayPage extends StatefulWidget {
  @override
  _SoruCevapDisplayPageState createState() => _SoruCevapDisplayPageState();
}

class _SoruCevapDisplayPageState extends State<SoruCevapDisplayPage> {
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
        title: Text('Sorular'),
      ),
      body: soruCeap == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: soruCeap!.length,
        itemBuilder: (context, index) {
          return SoruCevapCard(soruCevap: soruCeap![index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AskQuestionPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SoruCevapCard extends StatelessWidget {
  final SoruCevap soruCevap;

  SoruCevapCard({required this.soruCevap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          soruCevap.soru,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
        ),

      ),
    );
  }
}
