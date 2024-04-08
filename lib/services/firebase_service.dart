import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/post_model.dart';

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
    })
        .then((value) => print('Post added to Firestore'))
        .catchError((error) => print('Failed to add post: $error'));
  }

  Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await posts.get();
      List<Post> postList = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>; // Cast the data to a map
        // Ensure you have proper null checks and default values as necessary
        return Post(
          id: data['id'] ?? '', // Provide a default value in case it's null
          PostContent: data['PostContent'] ?? '',
        );
      }).toList();
      return postList;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }
}