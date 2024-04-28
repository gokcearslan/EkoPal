
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventName;
  final String eventDate;
  final String organizer;
  final String location;
  final String additionalInfo;
  bool isFavorite;
  String userId;

  Event({
    required this.eventName,
    required this.eventDate,
    required this.organizer,
    required this.location,
    required this.additionalInfo,
    this.isFavorite = false,
    required this.userId,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Event(
      eventName: data['eventName'] , // Use null-aware operators to handle missing fields
      eventDate: data['eventDate'] ,
      organizer: data['organizer'],
      location: data['location'] ,
      additionalInfo: data['additionalInfo'] ,
      userId: data['userId'],
    );
  }
}
