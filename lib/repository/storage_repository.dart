import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:divipay/datasource/firebase_storage_datasource.dart';

class StorageRepository {
  final FirebaseStorageDatasource datasource = FirebaseStorageDatasource();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    final imageUrl = datasource.uploadProfilePicture(userId, imageFile);

    await firestore.collection('users').doc(userId).update({
      'photoUrl': imageUrl,
    });

    return imageUrl;
  }
}
