import 'dart:io';

import 'package:divipay/repository/storage_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final StorageRepository repository = StorageRepository();

  Future<String> uploadProfilePicture(File imageFile) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final imageUrl = await repository.uploadProfilePicture(userId, imageFile);

    return imageUrl;
  }
}
