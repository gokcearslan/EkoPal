import 'package:cloud_firestore/cloud_firestore.dart';

class SoruCevap {

  final String soru;
  final String soruDetails;
  //final String cevap;
  final String userId;


  SoruCevap({required this.soru,
    required this.soruDetails,
    required this.userId,
  });

  factory SoruCevap.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return SoruCevap(
      soru: data['soru'],
      soruDetails: data['soruDetails'],
      userId: data['userId'],
    );
  }
}
