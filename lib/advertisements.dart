import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'advertisement_details_page.dart';
import 'colors.dart';
import 'create_page.dart';

class ViewAdvertisements extends StatefulWidget {
  const ViewAdvertisements({Key? key}) : super(key: key);

  @override
  _ViewAdvertisementsState createState() => _ViewAdvertisementsState();
}

class _ViewAdvertisementsState extends State<ViewAdvertisements> {
  List<Advertisement>? advertisements;
  StreamSubscription<List<Advertisement>>? adsSubscription;


  Stream<List<Advertisement>> getAdvertisementsStream() {
    return FirebaseFirestore.instance.collection('advertisements')
        .snapshots()
        .map((snapshot) {
      snapshot.docs.forEach((doc) {
        print('Doc dataprinted Hereeeeeeeeeeeeeeeeeeeeeeeeee: ${doc.data()}');
      });
      return snapshot.docs.map((doc) => Advertisement.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    adsSubscription = AdvertisementService().getAdvertisementsStream().listen(
            (updatedAdvertisements) {
          if (mounted) {
            setState(() {
              advertisements = updatedAdvertisements;
            });
          }
        },
        onError: (err) {
          print('Error listening to advertisement updates: $err');
        }

    );

    Future<String?> fetchAdvertisementImageUrl(String documentId) async {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('advertisements').doc(documentId).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['imageUrl'];
        } else {
          print("No such advertisement found");
          return null;
        }
      } catch (e) {
        print("Failed to fetch advertisement image URL: $e");
        return null;
      }
    }


  }
  @override
  void dispose() {
    adsSubscription?.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    final textTheme = Theme
        .of(context)
        .textTheme;


    return Scaffold(
      backgroundColor:white,
      appBar: AppBar(
        title: const Text(
          'İlanlar',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body:SafeArea(
        child: advertisements == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: advertisements!.length,
          itemBuilder: (context, index) {
            return buildAdCard(advertisements![index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreatePage(initialCategory: 'İlan')));
        },
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
        ),
        backgroundColor: lightButtonColor,
      ),

    );
  }


  Widget buildAdCard(Advertisement ad) {

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    print('Loading image for URLLLLLLLLLLLLLLLLLLL: ${ad.imageUrl}');
    print('Loading image for URLLLLLLLLLLLLLLLLLLL: ${ad.advertisementDetails}');
    print('Loading image for URLLLLLLLLLLLLLLLLLLL: ${ad.advertisementName}');
    print('Loading image for URLLLLLLLLLLLLLLLLLLL: ${ad.advertisementType}');



    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 5.0,
      color:cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ad.imageUrl != null)

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  ad.imageUrl!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text('Unable to load image');
                  },
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
                      Icon(Icons.arrow_circle_right_rounded, color: duyuruKoyuIcon),
                      SizedBox(width: 10),
                      Text(
                        ad.advertisementType ?? 'Empty Value',
                        style: theme.textTheme.subtitle1,

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
}


