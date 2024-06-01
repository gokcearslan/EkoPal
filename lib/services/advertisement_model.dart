import 'package:cloud_firestore/cloud_firestore.dart';

class Advertisement {
  final String advertisementName;
  final String? advertisementType;
  final String advertisementDetails;
  bool isFavorite;
  final String userId;
  final String? imageUrl;

  Advertisement({
    required this.advertisementName,
    required this.advertisementType,
    required this.advertisementDetails,
    this.isFavorite = false,
    required this.userId,
    this.imageUrl,

  });

  factory Advertisement.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    print("Data from Firestore: $data");
    return Advertisement(
      advertisementName: data['advertisementName'],
      advertisementType: data['advertisementType'],
      advertisementDetails: data['advertisementDetails'],
      userId: data['userId'],
      imageUrl: data['imageUrl'],
    );
  }
  Map<String, dynamic> toFirestore() {

    return {
      'advertisementName': advertisementName,
      'advertisementType': advertisementType,
      'advertisementDetails': advertisementDetails,
      'userId': userId,
      'isFavorite': isFavorite,
      'imageUrl': imageUrl,
    };
  }
  factory Advertisement.fromMap(Map<String, dynamic> map) {
    print("Data from Map: $map");
    return Advertisement(
      advertisementName: map['advertisementName'] ?? 'Default Name',
      advertisementType: map['advertisementType'],
      advertisementDetails: map['advertisementDetails'] ?? '',
      userId: map['userId'],
      imageUrl: map['imageUrl'],
    );
  }

}