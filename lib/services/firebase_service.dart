import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:ekopal/services/question_ans_model.dart';

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
    })
        .then((value) => print('Advertisement added to Firestore'))
        .catchError((error) => print('Failed to add advertisement: $error'));
  }

  Future<List<Advertisement>> getAdvertisements() async {
    try {
      QuerySnapshot querySnapshot = await advertisements.get();
      List<Advertisement> advertisementList = querySnapshot.docs.map((doc) {
        return Advertisement(
          advertisementName: doc['advertisementName'],
          advertisementType: doc['advertisementType'],
          advertisementDetails: doc['advertisementDetails'],

        );
      }).toList();
      return advertisementList;
    } catch (e) {
      print("Error fetching ads: $e");
      return [];
    }
  }
}

class DuyuruService {
  final CollectionReference duyurular =
  FirebaseFirestore.instance.collection('duyurular');

  Future<void> addDuyuru(Duyuru duyuru) {
    return duyurular
        .add({
      'duyuruName': duyuru.duyuruName,
      'duyuruType': duyuru.duyuruType,
      'duyuruDetails': duyuru.duyuruDetails,
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


  // post için vote
  Future<void> upvotePost(String postId) async {
    return posts.doc(postId).update({
      'upvotes': FieldValue.increment(1),
    }).catchError((error) {
      throw Exception("Failed to upvote: $error");
    });
  }

  Future<void> downvotePost(String postId) async {
    return posts.doc(postId).update({
      'downvotes': FieldValue.increment(1),
    }).catchError((error) {
      throw Exception("Failed to downvote: $error");
    });
  }


  //en çok oy alan 5 postu görüntüleme
  Future<List<Post>> getTopPosts() async {
    try {
      QuerySnapshot querySnapshot = await posts
          .orderBy('upvotes', descending: true)
          .limit(5)
          .get();

      List<Post> postList = querySnapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();

      return postList;
    } catch (e) {
      print("Error fetching top posts: $e");
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
      'cevap': soruCevap.cevap,
    })
        .then((value) => print('Soru-Cevap added to Firestore'))
        .catchError((error) => print('Failed to add Soru-Cevap: $error'));
  }

  Future<List<SoruCevap>> getSoruCevap() async {
    try {
      QuerySnapshot querySnapshot = await soruCevapCollection.get();
      List<SoruCevap> soruCevapList = querySnapshot.docs.map((doc) {
        return SoruCevap(
          soru: doc['soru'],
          cevap: doc['cevap'],
        );
      }).toList();
      return soruCevapList;
    } catch (e) {
      print("Error fetching Soru-Cevap: $e");
      return [];
    }
  }
}
