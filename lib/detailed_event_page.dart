import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/services/event_model.dart';

import 'colors.dart';

class DetailedEventPage extends StatefulWidget {
  final Event event;
  final bool isCurrentUser;

  DetailedEventPage({required this.event, this.isCurrentUser = false});

  @override
  _DetailedEventPageState createState() => _DetailedEventPageState();
}

class _DetailedEventPageState extends State<DetailedEventPage> {
  String? userName;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    String userId = widget.event.userId;
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
    final defaultTextStyle = TextStyle(fontSize: 16, color: Colors.black);


    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Etkinlik detayları",
          style: TextStyle(
            fontSize: 26,
          ),),
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
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.event.eventName,
                      style: const TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.event.additionalInfo,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today, color: duyuruKoyuIcon,),
                    title: Row(
                      children: [
                        Text('Etkinlik Tarihi: ', style: defaultTextStyle),
                        Text(widget.event.eventDate, style: defaultTextStyle),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.event_seat, color: duyuruKoyuIcon,),
                    title: Row(
                      children: [
                        Text('Düzenleyen: ', style: defaultTextStyle),
                        Text(widget.event.organizer, style: defaultTextStyle),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: duyuruKoyuIcon,),
                    title: Row(
                      children: [
                        Text('Konum: ', style: defaultTextStyle),
                        Text(widget.event.location, style: defaultTextStyle),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                              '${userName ?? 'Bilinmiyor'} tarafından oluşturuldu.',
                              style: defaultTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Icon(Icons.email, color: duyuruKoyuIcon),
                            SizedBox(width: 8),
                            Text(
                              'İletişim: ${userEmail ?? 'Bilinmiyor'}',
                              style: defaultTextStyle,
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
