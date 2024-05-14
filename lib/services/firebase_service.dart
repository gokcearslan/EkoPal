import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserManager.dart';
import 'advertisement_model.dart';
import 'duyuru_model.dart';

class EventService {
  final CollectionReference events =
  FirebaseFirestore.instance.collection('events');

  Future<void> addEvent(Event event) {
    return events
        .add({
      'eventName': event.eventName,
      'eventDate': event.eventDate,
      'organizer': event.organizer,
      'location': event.location,
      'additionalInfo': event.additionalInfo,
      'userId': event.userId,

    })
        .then((value) => print('Event added to Firestore'))
        .catchError((error) => print('Failed to add event: $error'));
  }
  Stream<List<Event>> getEventsStream() {
    return events.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>?; // Cast with null safety
        if (data == null) return null; // Check for null data and handle it appropriately

        return Event(
          eventName: data['eventName'] as String? ?? 'No Name', // Provide default values
          eventDate: data['eventDate'] as String? ?? 'No Date',
          organizer: data['organizer'] as String? ?? 'No Organizer',
          location: data['location'] as String? ?? 'No Location',
          additionalInfo: data['additionalInfo'] as String? ?? 'No Additional Info',
          userId: data['userId'] as String? ?? 'No User ID',
        );
      }).where((event) => event != null).cast<Event>().toList(); // Remove nulls and ensure type safety
    });
  }
}

class AdvertisementService {
  final CollectionReference advertisements =
  FirebaseFirestore.instance.collection('advertisements');

  Future<void> addAdvertisement(Advertisement advertisement) {
    return advertisements
        .add({
      'advertisementName': advertisement.advertisementName,
      'advertisementType': advertisement.advertisementType,
      'advertisementDetails': advertisement.advertisementDetails,
      'userId': advertisement.userId,

    })
        .then((value) => print('Advertisement added to Firestore'))
        .catchError((error) => print('Failed to add advertisement: $error'));
  }

  Stream<List<Advertisement>> getAdvertisementsStream() {
    return advertisements.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>?; // Explicitly cast to a nullable map
        if (data == null) {
          // Handle the case where data is null if necessary
          return null;
        }
        // Safely access the data fields with null checks or provide default values
        return Advertisement(
          advertisementName: data['advertisementName'] as String? ?? 'Unknown', // Provide default value if null
          advertisementType: data['advertisementType'] as String? ?? 'Unknown',
          advertisementDetails: data['advertisementDetails'] as String? ?? 'No details provided',
          userId: data['userId'] as String? ?? 'No user',
        );
      }).where((ad) => ad != null).cast<Advertisement>().toList(); // Remove null entries and cast back to Advertisement
    });
  }
}

class DuyuruService {
  final CollectionReference duyurular = FirebaseFirestore.instance.collection('duyurular');

  Future<void> addDuyuru(Duyuru duyuru) {


    return duyurular
        .add({
      'duyuruName': duyuru.duyuruName,
      'duyuruType': duyuru.duyuruType,
      'duyuruDetails': duyuru.duyuruDetails,
      'userId': duyuru.userId,
    })
        .then((value) => print('Duyuru added to Firestore'))
        .catchError((error) => print('Failed to add duyuru: $error'));
  }


}

class PostService {


  final CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<String?> getUserName(String userId) async {
    DocumentSnapshot userProfile = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userProfile['name'];
  }

  Future<void> addPost(Post post) async {

    String? userId = UserManager().userId;

    String? userName = await getUserName(userId!);

    return posts
        .add({
      'id': post.id,
      'PostContent': post.PostContent,
      'postTitle': post.postTitle,
      'upvotes': 0,
      'downvotes': 0,
      'userId': post.userId,
      'votedUsers': {},
      'createdBy': userName,

    })
        .then((value) => print('Gönderi başarıyla paylaşıldı.'))
        .catchError((error) => print('Gönderi paylaşılırken bir sorun oluştu: $error'));
  }

  Stream<List<Post>> getPostsStream() {
    return posts.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();
    });
  }

}

//soru cevap
class SoruCevapService {
  final CollectionReference soruCevapCollection =
  FirebaseFirestore.instance.collection('soru_cevap');

  Future<String?> getUserName(String userId) async {
    DocumentSnapshot userProfile = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userProfile['name'];
  }


  Future<void> addSoruCevap(SoruCevap soruCevap) async {

    String? userId = UserManager().userId;

    String? userName = await getUserName(userId!);


    return soruCevapCollection
        .add({
      'soru': soruCevap.soru,
      'soruDetails': soruCevap.soruDetails,
      'userId': soruCevap.userId,
      'createdBy': userName,
    })
        .then((value) => print('Soru ve açıklama added to Firestore'))
        .catchError((error) => print('Failed to add Soru: $error'));
  }

  Stream<List<SoruCevap>> getSoruCevapStream() {
    return soruCevapCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return SoruCevap(
          soru: data['soru'] as String,
          soruDetails: data['soruDetails'] as String,
          userId: data['userId'] as String,
            createdBy: data['createdBy'] as String,
        );
      }).toList();
    });
  }}