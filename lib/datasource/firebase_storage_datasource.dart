import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    final ref = _storage.ref().child('profile_images/$userId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
