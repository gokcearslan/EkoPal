import 'package:ekopal/colors.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:flutter/material.dart';

class AdvertisementDetailsPage extends StatelessWidget {

  final Advertisement ad;
  final bool isCurrentUser;

   AdvertisementDetailsPage({required this.ad, this.isCurrentUser = false});

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
        title: const Text("İlan detayları",
        style: TextStyle(
        fontSize: 26,
          ),),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body:SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            color:cardColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    ad.advertisementName,
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
                  leading: Icon(Icons.arrow_circle_right_rounded, color: Colors.blueGrey),
                  title: Text(ad.advertisementType ?? 'not defined' ),
                ),
                /*
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(ad.ad),
                ),


                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(ad.location),
                ),
                  */

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    ad.advertisementDetails,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Oluşturan: Bilge Ulcay',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('İletişime geç'),

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

