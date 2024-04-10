import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/post_model.dart';
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
  void _createPost() async {
    final String id = Random().nextInt(100000).toString();
    final String postContent = _postContentController.text;
    final String postTitle = _postTitleController.text;

    if (postContent.isNotEmpty) {
      final post = Post(id: id, PostContent: postContent, postTitle: postTitle);

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
        backgroundColor: colorScheme.primaryContainer, // Use primary container color for the app bar
        title: Text('Gönderi', style: TextStyle(color: colorScheme.onPrimaryContainer)), // Assuming 'onPrimaryContainer' is the color for text on top of primary containers
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimaryContainer), // Assuming 'onPrimaryContainer' is the color for icons on top of primary containers
        elevation: 1,
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
                  borderSide: BorderSide(
                    color: colorScheme.primary, // Border color when the TextField is focused
                    width: 2.0,
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
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2.0,
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
                onPressed: _createPost,
                child: Text('Gönderi Oluşturun'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimaryContainer, // Assuming 'onPrimaryContainer' is the text color for buttons
                  backgroundColor: colorScheme.primaryContainer, // Button background color from the color scheme
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),

        ],
        ),
        ),
        );
  }



}