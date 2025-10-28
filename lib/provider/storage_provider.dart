import 'package:divipay/service/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider =
    Provider((ref) => StorageService());
