import 'package:ekopal/colors.dart';
import 'package:flutter/material.dart';

class EkoBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EkoBot'),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Text(
          'BURASI EKOBOT İÇİN OLUŞTURULDU',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
