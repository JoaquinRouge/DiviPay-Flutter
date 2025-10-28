import 'dart:typed_data';
import 'package:divipay/datasource/storage_datasource.dart';

class StorageRepository {
  final StorageDataSource datasource = StorageDataSource();

  Future<String> uploadProfilePicture(Uint8List fileBytes, String userId) async {
    final imageUrl = datasource.uploadProfilePicture(fileBytes,userId);

    return imageUrl;
  }
}
