import 'package:ekopal/sharings_advertisement.dart';
import 'package:ekopal/sharings_announcements.dart';
import 'package:ekopal/sharings_events.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'colors.dart';
import 'colors.dart';
import 'colors.dart';

class MySharingsPage extends StatefulWidget {

  @override
  _MySharingsPageState createState() => _MySharingsPageState();
}

class _MySharingsPageState extends State<MySharingsPage> {

  @override
  void initState() {
    super.initState();

  }

  List<Category> categories = [
    Category(icon: Icons.announcement, name: 'İlanlarım', widget: SharingViewAds(),color: Colors.black54),
    Category(icon: Icons.campaign, name: 'Duyurularım', widget: SharingViewAnnouncements(),color: Colors.black54),
    Category(icon: Icons.event, name: 'Etkinliklerim', widget: SharingViewEvents(),color:Colors.black54),
    Category(icon: Icons.announcement, name: 'İlanlarım', widget: SharingViewAds(),color: Colors.black54),
    Category(icon: Icons.campaign, name: 'Duyurularım', widget: SharingViewAnnouncements(),color: Colors.black54),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paylaşım Kategorileri'),
        backgroundColor: appBarColor,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Each item takes a full row
          crossAxisSpacing: 10,
          mainAxisSpacing: 20, // Increased spacing for better visual separation
          childAspectRatio: 2, // Adjusted aspect ratio
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => categories[index].widget,
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 5,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categories[index].icon, size: 80, color: categories[index].color ?? Colors.black54),
                  SizedBox(height: 8),
                  Text(
                    categories[index].name,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        decoration: TextDecoration.underline
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

class Category {
  final IconData icon;
  final String name;
  final Widget widget;
  final Color? color;


  Category({required this.icon, required this.name, required this.widget, this.color});
}


