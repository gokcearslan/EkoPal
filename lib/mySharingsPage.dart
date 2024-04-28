import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySharingsPage extends StatefulWidget {
  @override
  _MySharingsPageState createState() => _MySharingsPageState();
}

class _MySharingsPageState extends State<MySharingsPage> {
  List<Duyuru> _userAnnouncements = [];
  List<Advertisement> _userAdvertisement = [];

  bool _isLoading = true;
  bool _isLoaded=true;

  @override
  void initState() {
    super.initState();
    fetchUserAnnouncements();
    fetchUserAdvertisements();
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
                return ListTile(
                  title: Text(ad.advertisementName),
                  //basıp detay görüntüle dediğinde görmesi gerek
                  //subtitle: Text(ad.advertisementDetails),
                  subtitle: Text("Tür: İlan"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

