import 'package:flutter/material.dart';

class AdvertisementDetailsPage extends StatefulWidget {
  const AdvertisementDetailsPage({Key? key}) : super(key: key);

  @override
  _AdvertisementDetailsPageState createState() =>
      _AdvertisementDetailsPageState();
}

class _AdvertisementDetailsPageState extends State<AdvertisementDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertisement Details'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Advertisement Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Advertisement Description',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
