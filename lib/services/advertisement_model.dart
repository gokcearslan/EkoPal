import 'package:cloud_firestore/cloud_firestore.dart';

class Advertisement {
  final String advertisementName;
  final String? advertisementType;
  final String advertisementDetails;
  bool isFavorite;
  final String userId;

  Advertisement({
    required this.advertisementName,
    required this.advertisementType,
    required this.advertisementDetails,
    this.isFavorite = false,
    required this.userId,

  });

  factory Advertisement.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Advertisement(
      advertisementName: data['advertisementName'],
      advertisementType: data['advertisementType'],
      advertisementDetails: data['advertisementDetails'],
      userId: data['userId'],
    );
  }
}
