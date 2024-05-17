import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img_lib;

class ImageService {
  final ImagePicker _picker = ImagePicker();




  Future<void> pickAndUploadImage(ImageSource source, String filePath, String collectionPath, String docId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) return;

    final XFile? pickedFile = await _picker.pickImage(source: source, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      img_lib.Image? originalImage = img_lib.decodeImage(await imageFile.readAsBytes());

      if (originalImage != null) {
        img_lib.Image resized = img_lib.copyResize(originalImage, width: 1024, height: 1024);
        List<int> jpg = img_lib.encodeJpg(resized, quality: 70);

        Directory tempDir = await getTemporaryDirectory();
        String targetPath = "${tempDir.path}/temp.jpg";
        File targetFile = File(targetPath)..writeAsBytesSync(jpg);

        String fullFilePath = '$filePath/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot snapshot = await FirebaseStorage.instance.ref(fullFilePath).putFile(targetFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection(collectionPath).doc(docId).update({
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