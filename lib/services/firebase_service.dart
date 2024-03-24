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
}
