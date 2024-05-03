import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'colors.dart';

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _postContentController = TextEditingController();
  final TextEditingController _postTitleController = TextEditingController(); // New controller for post title
  final PostService _postService = PostService();

  //random id yaratma
  void _createPost(String userId) async {
    final String id = Random().nextInt(100000).toString();
    final String postContent = _postContentController.text;
    final String postTitle = _postTitleController.text;


    if (postContent.isNotEmpty) {
      final post = Post(id: id, PostContent: postContent, postTitle: postTitle,userId: userId);

      await _postService.addPost(post).then((value) {
        print("Postunuz başarıyla paylaşıldı");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Postunuz başarıyla paylaşıldı')));
      }).catchError((error) {
        print("Paylaşma sırasında bir hata oluştu: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paylaşma sırasında bir hata oluştu')));
      });

      _postContentController.clear();
      _postTitleController.clear();

    } else {
      print("Bu alan boş kalamaz.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bu alan boş kalamaz.')));
    }
  }

  @override
  void dispose() {
    _postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: colorScheme.onSurface.withOpacity(0.5), // Adjust the opacity as you see fit
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gönderi Oluştur',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _postTitleController,
              decoration: InputDecoration(
                hintText: 'Başlık',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                filled: true,
                fillColor: colorScheme.surface,
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                    color: backgroundColor,
                    width: 3.0,
                  ),
                ),
                prefixIcon: Icon(Icons.title, color: colorScheme.onSurface),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _postContentController,
              decoration: InputDecoration(
                hintText: 'İçeriğin ne hakkında?',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                filled: true,
                fillColor: colorScheme.surface,
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                    color: backgroundColor,
                    width: 3.0,
                  ),
                ),
                prefixIcon: Icon(Icons.short_text, color: colorScheme.onSurface),
              ),
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.image, color: colorScheme.onSurface),
                  onPressed: () {}, // TODO: Implement your image upload logic
                ),
                // Add more icons if needed
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(

                onPressed: () async {
                  String? userId = FirebaseAuth.instance.currentUser?.uid;

                  if (userId == null) {
                    print('No user logged in');
                    return;
                  }
                  _createPost(userId);
                },
                child: Text('     Oluştur     '),
                style: ElevatedButton.styleFrom(
                  foregroundColor: textColor,
                  backgroundColor: backgroundColor,
                  textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  padding: EdgeInsets.symmetric(horizontal: 118, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



}