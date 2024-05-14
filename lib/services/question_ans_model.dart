import 'package:cloud_firestore/cloud_firestore.dart';

class SoruCevap {

  final String soru;
  final String soruDetails;
  final String userId;
  final String createdBy;



  SoruCevap({required this.soru,
    required this.soruDetails,
    required this.userId,
    required this.createdBy,

  });

  factory SoruCevap.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return SoruCevap(
      soru: data['soru'],
      soruDetails: data['soruDetails'],
      userId: data['userId'],
      createdBy: data['createdBy'],

    );
  }
}
