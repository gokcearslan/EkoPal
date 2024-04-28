
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'advertisement_details_page.dart';
import 'detailed_event_page.dart';


class MySharingsPage extends StatefulWidget {
  @override
  _MySharingsPageState createState() => _MySharingsPageState();
}

class _MySharingsPageState extends State<MySharingsPage> {
  List<Duyuru> _userAnnouncements = [];
  List<Advertisement> _userAdvertisement = [];
  List<Event> _userEvents = [];


  bool _isLoading = true;
  bool _isLoaded=true;
  bool _isEventsLoaded = true;


  @override
  void initState() {
    super.initState();
    fetchUserAnnouncements();
    fetchUserAdvertisements();
    fetchUserEvents();
  }

  Future<void> fetchUserAnnouncements() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('duyurular')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _userAnnouncements = querySnapshot.docs.map((doc) => Duyuru.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isLoading = false));
  }


  Future<void> fetchUserAdvertisements() async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoaded = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('advertisements')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _userAdvertisement = querySnapshot.docs.map((doc) => Advertisement.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isLoaded = false));

  }
  Future<void> fetchUserEvents() async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isEventsLoaded = false);
      return;
    }

    FirebaseFirestore.instance
        .collection('events')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _userEvents = querySnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    })
        .catchError((error) => print("Failed to fetch user posts: $error"))
        .whenComplete(() => setState(() => _isEventsLoaded = false));

  }


  Widget buildEventCard(Event event) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column for the Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://i.pinimg.com/564x/12/ad/fa/12adfa1035792c44248d3eab35212c91.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.eventName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.location,
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  // Date Information
                  Text(
                    event.eventDate, // Date information
                    style: theme.textTheme.bodyText2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          event.isFavorite ? Icons.star : Icons.star_border,
                          color: event.isFavorite ? Colors.amber : colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            event.isFavorite = !event.isFavorite;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedEventPage(event: event),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildAdCard(Advertisement ad) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://mahimeta.com/wp-content/uploads/2021/07/5-Simple-Tips-to-Increase-Revenue-from-Website-Ads-Website.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ad.advertisementName,
                    style: theme.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children:[
                      Icon(Icons.arrow_circle_right_rounded, color: Colors.blueGrey), // Icon widget
                      SizedBox(width: 10),
                      Text(
                        ad.advertisementType ?? 'Empty Value',
                        style: theme.textTheme.subtitle1,
                        //add_home_work_outlined

                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Text(
                    ad.advertisementDetails,
                    style: theme.textTheme.bodyText2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          ad.isFavorite ? Icons.star_outline : Icons.star_border,
                          color: ad.isFavorite ? Colors.amber : colorScheme
                              .onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            ad.isFavorite = !ad.isFavorite;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.article_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdvertisementDetailsPage(ad: ad),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paylaşımlarım"),

      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _userAnnouncements.isEmpty
                ? Center(child: Text("Paylaşım bulunamadı."))
                : ListView.builder(
              itemCount: _userAnnouncements.length,
              itemBuilder: (context, index) {
                Duyuru announcement = _userAnnouncements[index];
                return ListTile(
                  title: Text(announcement.duyuruName),
                  subtitle: Text("Tür: Duyuru"),
                  //basıp detay görüntüle dediğinde görmesi gerek
                  //subtitle: Text(announcement.duyuruDetails),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoaded
                ? Center(child: CircularProgressIndicator())
                : _userAdvertisement.isEmpty
                ? Center(child: Text("İlan bulunamadı."))
                : ListView.builder(
              itemCount: _userAdvertisement.length,
              itemBuilder: (context, index) {
                Advertisement ad = _userAdvertisement[index];
                return buildAdCard(_userAdvertisement[index]);
              },
            ),
          ),
          Expanded(
            child: _isEventsLoaded
                ? Center(child: CircularProgressIndicator())
                : _userEvents.isEmpty
                ? Center(child: Text("Etkinlik bulunamadı."))
                : ListView.builder(
              itemCount: _userEvents.length,
              itemBuilder: (context, index) {
                return buildEventCard(_userEvents[index]);  // Use your buildEventCard method here
              },
            ),
          ),


        ],
      ),
    );
  }

}

