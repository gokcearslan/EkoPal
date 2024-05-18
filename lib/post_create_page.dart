import 'dart:io';  // Correct import for using File with local file system

import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

import 'colors.dart';

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _postContentController = TextEditingController();
  final TextEditingController _postTitleController = TextEditingController();
  final PostService _postService = PostService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _uploadedImageUrl; // State variable to hold the uploaded image URL


  void _submitPostandNavigateToDisplayPosts() {
    Navigator.of(context).pop();  // To close the screen after submitting
  }

  //random id yaratma
  void _createPost(String userId) async {
    final String id = Random().nextInt(100000).toString();
    final String postContent = _postContentController.text;
    final String postTitle = _postTitleController.text;


    if (postContent.isNotEmpty) {
      String? userName = await _postService.getUserName(userId);

      if (userName == null) {
        print("User name could not be fetched");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User name could not be fetched')));
        return;
      }

      final post = Post(id: id, PostContent: postContent, postTitle: postTitle,userId: userId, createdBy: userName,
        imageUrl: _uploadedImageUrl, // Include the image URL
      );

      await _postService.addPost(post).then((value) {

        print("Gönderiniz başarıyla paylaşıldı");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Postunuz başarıyla paylaşıldı')));

      }).catchError((error) {
        print("Paylaşma sırasında bir hata oluştu: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paylaşma sırasında bir hata oluştu')));
      });

      _postContentController.clear();
      _postTitleController.clear();
      _submitPostandNavigateToDisplayPosts();

    } else {
      print("Bu alan boş kalamaz.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bu alan boş kalamaz.')));
    }
  }


  Future<String?> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);  // Ensure 'File' is from 'dart:io'
      String fileName = 'postImages/${DateTime.now().millisecondsSinceEpoch}_${Uri.file(image.path).pathSegments.last}';
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print("Failed to upload image: $e");
        return null;
      }
    } else {
      print("No image selected");
      return null;
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
        color: colorScheme.onSurface.withOpacity(0.5),
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

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (_uploadedImageUrl == null) // Display the IconButton only if no image has been uploaded
                      IconButton(
                        icon: Icon(Icons.add_photo_alternate, size: 50),
                        onPressed: () async {
                          String? imageUrl = await uploadImage();
                          if (imageUrl != null) {
                            setState(() {
                              _uploadedImageUrl = imageUrl; // Save the uploaded image URL
                            });
                            //ScaffoldMessenger.of(context).showSnackBar(
                            //  SnackBar(content: Text('Image uploaded successfully')),
                            //);
                          } else {
                           // ScaffoldMessenger.of(context).showSnackBar(
                             // SnackBar(content: Text('Failed to upload image')),
                           // );
                          }
                        },
                      ),
                    if (_uploadedImageUrl != null) // Display the uploaded image if available
                      Image.network(
                        _uploadedImageUrl!,
                        width: 350, // Specify a width for the image
                        height: 300, // Specify a height for the image
                        fit: BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio while filling the bounds
                      ),
                  ],
                ),
                SizedBox(height: 20),

                TextFormField(
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
                        color: backgroundColor,
                        width: 3.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.title, color: colorScheme.onSurface),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Başlık boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
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
                        color: backgroundColor,
                        width: 3.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.short_text, color: colorScheme.onSurface),
                  ),
                  minLines: 5,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İçerik boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                //FOTO EKLEME YERİ

                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String? userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user logged in')));
                          return;
                        }
                        _createPost(userId);
                      }
                    },
                    child: Text('Oluştur'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: textColor,
                      backgroundColor: backgroundColor,
                      textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.symmetric(horizontal: 140, vertical: 16),
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
        ),
      ),
    );
  }

}