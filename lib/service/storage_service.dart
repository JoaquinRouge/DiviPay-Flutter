import 'dart:typed_data';

import 'package:divipay/repository/storage_repository.dart';
import 'package:divipay/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final StorageRepository repository = StorageRepository();
  final UserService userService = UserService();

  Future<String> uploadProfilePicture(Uint8List fileBytes) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final imageUrl = await repository.uploadProfilePicture(fileBytes, userId);

    userService.addImageUrl(imageUrl);

    return imageUrl;
  }
}
