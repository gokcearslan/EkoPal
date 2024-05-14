import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String answer;
  final String createdBy;
  final DateTime timestamp;

  Answer({
    required this.answer,
    required this.createdBy,
    required this.timestamp,
  });

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Answer(
      answer: data['answer'] ?? '',
      createdBy: data['createdBy'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'createdBy': createdBy,
      'timestamp': timestamp,
    };
  }
}
