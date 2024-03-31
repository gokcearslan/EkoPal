import 'package:ekopal/services/advertisement_model.dart';
import 'package:flutter/material.dart';

class AdvertisementDetailsPage extends StatelessWidget {

  final Advertisement ad;
  final bool isCurrentUser;

   AdvertisementDetailsPage({required this.ad, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İlan detayları"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    ad.advertisementName,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Image.network(
                  'https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg',
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
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
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Created by: "" ',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('Message'),

                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement navigation to message page
                        },
                        child: Text('Edit'),
                        /* USER condition eklenince burası kullılacak
                      if (isCurrentUser) // Conditional edit button
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Implement navigation to editing page
                          },
                        ),

                       */
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

