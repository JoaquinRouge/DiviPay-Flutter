import 'package:divipay/datasource/firebase_auth_datasource.dart';
import 'package:divipay/repository/auth_repository.dart';
import 'package:divipay/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// DataSource
final firebaseAuthDataSourceProvider = Provider(
  (_) => FirebaseDataSource(),
);

// Repository
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(firebaseAuthDataSourceProvider)),
);

// Service
final authServiceProvider = Provider(
  (ref) => AuthService(ref.watch(authRepositoryProvider)),
);
