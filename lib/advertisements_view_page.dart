import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'advertisement_details_page.dart';


class ViewAds extends StatefulWidget {
  const ViewAds({Key? key}) : super(key: key);

  @override
  _ViewAdsState createState() => _ViewAdsState();
}

class _ViewAdsState extends State<ViewAds> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlanlar', style: TextStyle(fontSize: 24)),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('advertisements').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ViewAdvertisementCard(data: data);
            }).toList(),
          );
        },
      )
    );
  }
}

class ViewAdvertisementCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ViewAdvertisementCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Container(
        height: 200,

        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['advertisementName'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'İlan türü: ' + data['advertisementType'],
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 56,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: 50,
                    height: 100,
                    child: Stack(
                      children: [
                        FittedBox(
                          fit: BoxFit.cover,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200.0),
                            child: Image.network(
                              'https://static1.squarespace.com/static/54226625e4b072e9cb9647ad/t/652dcdf4c396223abddc16ee/1702859506677/',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ElevatedButton(
                            onPressed: () {
                              /*
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdvertisementDetailsPage(),
                              ));

                               */
                            },
                            child: Text('Button'),
                          ),
                        ),
                      ],
                    ),
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


