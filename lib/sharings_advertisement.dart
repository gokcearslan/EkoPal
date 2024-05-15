import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'advertisement_details_page.dart';
import 'colors.dart';

class SharingViewAds extends StatefulWidget {
  @override
  _SharingViewAdsState createState() => _SharingViewAdsState();
}

class _SharingViewAdsState extends State<SharingViewAds> {
  List<Advertisement> _userAdvertisement = [];
  bool _isLoaded=true;

  @override
  void initState() {
    super.initState();
    fetchUserAdvertisements();
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

  Widget buildAdCard(Advertisement ad) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 5.0,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://img3.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/88/73/d4/908040653.jpg',
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
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children:[
                      const Icon(Icons.arrow_circle_right_rounded, color: duyuruKoyuIcon), // Icon widget
                      const SizedBox(width: 10),
                      Text(
                        ad.advertisementType ?? 'Empty Value',
                        style: theme.textTheme.titleMedium,
                        //add_home_work_outlined

                      ),

                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    ad.advertisementDetails,
                    style: theme.textTheme.bodyMedium,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.article_outlined,
                          //color: colorScheme.onSurfaceVariant,
                            color: Colors.deepPurple
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
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.deepPurple),
                        onPressed: () {
                          // Placeholder for future edit functionality
                          print('Edit button tapped');
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
        title: const Text(
          'İlanlarım',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
    body:SafeArea(
    child: Column(
    children: [
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
    ],
    ),
    ),
    );
  }

}