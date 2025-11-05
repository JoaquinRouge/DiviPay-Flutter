// data/datasource/storage_datasource.dart
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadProfilePicture(
    Uint8List fileBytes,
    String userId,
  ) async {
    final path = '$userId.png';

    // Subimos el archivo
    await _client.storage
        .from('divipay_profile_pictures')
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final url = _client.storage
        .from('divipay_profile_pictures')
        .getPublicUrl(path);

    return url;
  }
}
