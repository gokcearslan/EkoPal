import 'package:cloud_firestore/cloud_firestore.dart';

class Duyuru {
  final String duyuruName;
  final String? duyuruType;
  final String duyuruDetails;
  final String userId;

  Duyuru({ required this.duyuruName,
    required this.duyuruType,
    required this.duyuruDetails,
    required this.userId});


  factory Duyuru.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Duyuru(
      duyuruName: data['duyuruName'],
      duyuruType: data['duyuruType'],
      duyuruDetails: data['duyuruDetails'],
      userId: data['userId'],
    );
  }

/*
  Duyuru({
    required this.duyuruName,
    required this.duyuruType,
    required this.duyuruDetails,
  });

 */
}
