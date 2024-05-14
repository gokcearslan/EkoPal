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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
        centerTitle: true,
        backgroundColor:appBarColor,
        title: const Text('Sorun varsa, Gönder!',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller:_soruController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      }
                      return null;
                    },              decoration: InputDecoration(
                    labelText: 'Soru Başlığı',
                    hintText: 'Soruyu özetleyen bir başlık seçin.',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color:backgroundColor)),
                  ),
                    maxLength: 45, //maz karakter sınırı
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller:_soruDetailsController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      }
                      return null;
                    },              decoration: InputDecoration(
                    labelText: 'Soru İçeriği',
                    hintText: 'Sorunuzdan kısaca bahsedin.',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: backgroundColor),
                    ),
                    alignLabelWithHint: true,
                  ),
                    maxLines: 6,
                    textInputAction: TextInputAction.newline,
                  ),
                  SizedBox(height: 20),
                  //FOTO EKLEME YERİ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add_photo_alternate, size: 50),
                        onPressed: () {
                          // Functionality to be implemented later
                          print('Icon to add image pressed');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity, // makes the button stretch to full width
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? userId = FirebaseAuth.instance.currentUser?.uid;

                          if (userId == null) {
                            print('No user logged in');
                            return;
                          }

                          SoruCevap soruCevap = SoruCevap(
                            soru: _soruController.text,
                            soruDetails: _soruDetailsController.text,
                            userId: userId,
                            createdBy: "default name"
                          );
                          SoruCevapService().addSoruCevap(soruCevap);
                          _soruController.clear();
                          _submitQuestion();
                        }
                      },
                      child: Text('Sorum var!',style: TextStyle(
                          color: Colors.black,fontSize:22),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: buttonColor1,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
