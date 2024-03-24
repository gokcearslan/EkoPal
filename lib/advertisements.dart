import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'advertisement_details_page.dart';

class CardExamplesApp extends StatefulWidget {
  const CardExamplesApp({Key? key}) : super(key: key);

  @override
  _CardExamplesAppState createState() => _CardExamplesAppState();
}

class _CardExamplesAppState extends State<CardExamplesApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlanlar', style: TextStyle(fontSize: 24)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('advertisements').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var document = data[index];
              return Card.filled(child: _SampleCard());
            },
          );
        },
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 300,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('advertisements').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          }
          return SingleChildScrollView(
              child: Column(
              children: data.map((document) {
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    child: Image.network(
                      'https://m.media-amazon.com/images/I/81F38erQmuL._AC_UF1000,1000_QL80_.jpg',
                      fit: BoxFit.scaleDown,
                      width: 200,
                      height: 120,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document['advertisementName'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        document['advertisementType'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    document['advertisementDetails'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 16), // to add spacing between ListTiles
              ],
            );
          }).toList(),
              ),
          );
        },
      ),
    );
  }

}


