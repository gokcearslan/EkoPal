import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/services/image_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ekopal/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'change_password_page.dart';

//design değiştirilecek ama isim çekemiyorum collection olmadığı için
// collection oluşturunca isim+ profil resmi gözükecek


class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();

  Future<String?> fetchImageFromFirestore(String userId) async {
    ImageService imageService = ImageService();
    String? base64Image = await imageService.getImageFromFirestore(userId);
    return base64Image;
  }
}

class _ProfilePageState extends State<ProfilePage> {
  ImageService _imageService = ImageService();

  String name = '';
  String? _base64Image;

  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  User? _currentUser;

  void fetchUser() {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot userSnapshot) {
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
          String name = userData['name'] as String;

          setState(() {
            this.name = name;
          });
        } else {
          print('Böyle bir kullanıcı bulunmamaktadır.');
        }
      }).catchError((error) {
        print(error);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchImage() async {
    String? base64Image = await widget.fetchImageFromFirestore(
        FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _base64Image = base64Image ?? '';
    });
  }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    fetchImage();
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                    border: Border.all(color: somon, width: 1),
                    image: _base64Image?.isNotEmpty ?? false
                        ? DecorationImage(
                      image: MemoryImage(Uint8List.fromList(
                        base64Decode(_base64Image!),
                      )),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                ),
                Positioned(
                  right: width * 0.01,
                  bottom: height * 0.05,
                  child: Container(
                    width: width * 0.15,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                      color: Color(0xfff2f9fe),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Color(0xFF001489), width: 1),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final action = CupertinoActionSheet(
                          title: Text(
                            "Picture",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFF001489),
                            ),
                          ),
                          message: Text(
                            "Select a picture",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFF001489)
                                  .withOpacity(0.7),
                            ),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(
                                "Camera",
                                style: TextStyle(
                                    color: Color(0xFF001489)),
                              ),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                                _imageService
                                    .pickAndSetImageFromCamera();
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(
                                "Gallery",
                                style: TextStyle(
                                    color: Color(0xFF001489)),
                              ),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                                _imageService
                                    .pickAndSetImageFromGallery();
                              },
                            ),
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Close"),
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Color(0xFF001489),
                        size: width * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${_currentUser?.email ?? 'There is no such info'}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _currentUser?.emailVerified == true
                      ? Text(
                    'Email confirmed',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  )
                      : Text(
                    'Email could not be confirmed',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _currentUser != null &&
                        !_currentUser!.emailVerified
                        ? () async {
                      setState(() {
                        _isSendingVerification = true;
                      });
                      await _currentUser!
                          .sendEmailVerification();
                      setState(() {
                        _isSendingVerification = false;
                      });
                    }
                        : null,
                    child: _isSendingVerification
                        ? CircularProgressIndicator()
                        : Text(
                      'Confirm Email',
                      style: TextStyle(color: Color(0xFFffffff)),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_currentUser != null &&
                              _currentUser!.emailVerified) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordPage(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Change Password',
                          style: TextStyle(color: Color(0xFFffffff)),
                        ),
                        style: _currentUser != null &&
                            _currentUser!.emailVerified
                            ? ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                            : ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.purple.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSigningOut = true;
                          });
                          await FirebaseAuth.instance.signOut();
                          setState(() {
                            _isSigningOut = false;
                          });
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Çıkış',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 8),
                            Icon(Icons.exit_to_app, color: Colors.white),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
