/*import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoruCevapPage extends StatefulWidget {
  @override
  _SoruCevapPageState createState() => _SoruCevapPageState();
}

class _SoruCevapPageState extends State<SoruCevapPage> {
  TextEditingController _soruController = TextEditingController();
  TextEditingController _cevapController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soru-Cevap Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _soruController,
              decoration: InputDecoration(
                labelText: 'Soru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cevapController,
              decoration: InputDecoration(
                labelText: 'Cevap',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                SoruCevap soruCevap = SoruCevap(
                  soru: _soruController.text,
                  cevap: _cevapController.text,
                );
                SoruCevapService().addSoruCevap(soruCevap);
                _soruController.clear();
                _cevapController.clear();
              },
              child: Text('Soru-Cevap Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}

 */
