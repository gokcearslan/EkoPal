import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'advertisement_details_page.dart';

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
        title: Text("İlanlarım"),

    ),
    body: Column(
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
    );
  }

}