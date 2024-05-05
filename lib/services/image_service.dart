import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img_lib;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage(ImageSource source) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) return;

    final XFile? pickedFile = await _picker.pickImage(source: source, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final img_lib.Image? originalImage = img_lib.decodeImage(await imageFile.readAsBytes());

      if (originalImage != null) {
        // Resize and compress image
        final img_lib.Image resized = img_lib.copyResize(originalImage, width: 1024, height: 1024);
        final List<int> jpg = img_lib.encodeJpg(resized, quality: 70);

        // Save the compressed image to a temporary file
        final Directory tempDir = await getTemporaryDirectory();
        final String targetPath = "${tempDir.path}/temp.jpg";
        final File targetFile = File(targetPath)..writeAsBytesSync(jpg);

        // Upload the image to Firebase Storage
        final String filePath = 'profile_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final TaskSnapshot snapshot = await FirebaseStorage.instance.ref(filePath).putFile(targetFile);
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with the image URL
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'imageUrl': downloadUrl,
        });
      }
    }
  }

  Future<String?> getImageUrlFromFirestore(String userId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (snapshot.exists) {
        final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        return data?['imageUrl'];
      } else {
        print('Document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error retrieving image URL: $e');
      return null;
    }
  }
}
