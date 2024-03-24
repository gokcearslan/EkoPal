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
    return MaterialApp(
      home: ddsdsd(),
    );
  }
}

class ddsdsd extends StatelessWidget {
  const ddsdsd({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlanlar',style: TextStyle(fontSize: 24)),
      ),
      body: ListView(
        children: [
          Card.filled(child: _SampleCard()),
          Card.filled(child: _SampleCard()),
        ],
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              child: Image.network(
                'https://m.media-amazon.com/images/I/81F38erQmuL._AC_UF1000,1000_QL80_.jpg',
                fit: BoxFit.scaleDown,
                width: 120,
                height: 120,
              ),
            ),
            title: Text(
              'İlan Başlığı',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              'İlan Detayları',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 16), // to add spacing between ListTile and button
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdvertisementDetailsPage()),
                );
              },
              label: Text('Detaylara git'),
              splashColor: Colors.white,
            ),
          ),
        ],
      ),
    );

  }
}


