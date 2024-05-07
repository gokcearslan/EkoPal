import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await events.get();
      List<Event> eventList = querySnapshot.docs.map((doc) {
        return Event(
          eventName: doc['eventName'],
          eventDate: doc['eventDate'],
          organizer: doc['organizer'],
          location: doc['location'],
          additionalInfo: doc['additionalInfo'],
          userId: doc['userId'],


        );
      }).toList();
      return eventList;
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
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

  Future<void> addPost(Post post) {
    return posts
        .add({
      'id': post.id,
      'PostContent': post.PostContent,
      'postTitle': post.postTitle,
      'upvotes': 0,
      'downvotes': 0,
      'userId': post.userId,
      'votedUsers': {},

    })
        .then((value) => print('Gönderi başarıyla paylaşıldı.'))
        .catchError((error) => print('Gönderi paylaşılırken bir sorun oluştu: $error'));
  }

  Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await posts.get();
      List<Post> postList = querySnapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();
      print("Fetched posts: $postList"); // Debug line
      return postList;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

}

//soru cevap
class SoruCevapService {
  final CollectionReference soruCevapCollection =
  FirebaseFirestore.instance.collection('soru_cevap');

  Future<void> addSoruCevap(SoruCevap soruCevap) {
    return soruCevapCollection
        .add({
      'soru': soruCevap.soru,
      'soruDetails': soruCevap.soruDetails,
      'userId': soruCevap.userId,
    })
        .then((value) => print('Soru ve açıklama added to Firestore'))
        .catchError((error) => print('Failed to add Soru: $error'));
  }

  Future<List<SoruCevap>> getSoruCevap() async {
    try {
      QuerySnapshot querySnapshot = await soruCevapCollection.get();
      List<SoruCevap> soruCevapList = querySnapshot.docs.map((doc) {
        return SoruCevap(
          soru: doc['soru'],
          soruDetails: doc['soruDetails'],
          userId: doc['userId'],
        );
      }).toList();
      return soruCevapList;
    } catch (e) {
      print("Error fetching Soru: $e");
      return [];
    }
  }
}