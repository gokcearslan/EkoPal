import 'package:ekopal/colors.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdvertisementDetailsPage extends StatefulWidget {
  final Advertisement ad;
  final bool isCurrentUser;

  AdvertisementDetailsPage({required this.ad, this.isCurrentUser = false});

  @override
  _AdvertisementDetailsPageState createState() => _AdvertisementDetailsPageState();
}

class _AdvertisementDetailsPageState extends State<AdvertisementDetailsPage> {
  String? userName;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    String userId = widget.ad.userId; // Ensure this key exists in your data
    Map<String, String?> userInfo = await fetchUserInfo(userId);
    setState(() {
      userName = userInfo['name'];
      userEmail = userInfo['email'];
      isLoading = false;
    });
  }

  Future<Map<String, String?>> fetchUserInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return {
          'name': userDoc['name'],
          'email': userDoc['email'],
        };
      } else {
        return {
          'name': null,
          'email': null,
        };
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return {
        'name': null,
        'email': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          "İlan detayları",
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.ad.advertisementName,
                      style: const TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  Image.network(
                    'https://img3.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/88/73/d4/908040653.jpg',
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_circle_right_rounded, color: duyuruKoyuIcon),
                    title: Text('İlan türü: ${widget.ad.advertisementType ?? 'not defined'}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.ad.advertisementDetails,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: duyuruKoyuIcon),
                            SizedBox(width: 8),
                            Text(
                              'Oluşturan: ${userName ?? 'Bilinmiyor'}',
                              style: textTheme.bodyText2,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.email, color: duyuruKoyuIcon),
                            SizedBox(width: 8),
                            Text(
                              'İletişim: ${userEmail ?? 'Bilinmiyor'}',
                              style: textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
