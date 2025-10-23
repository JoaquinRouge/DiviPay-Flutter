import 'package:firebase_auth/firebase_auth.dart';
import 'package:divipay/datasource/firebase_auth_datasource.dart';

class AuthRepository {
  final FirebaseDataSource dataSource;

  AuthRepository(this.dataSource);

  Future<User?> register(String email, String username, String password) =>
      dataSource.register(email, username, password);

  Future<User?> login(String email, String password) =>
      dataSource.login(email, password);

  Future<void> logout() => dataSource.logout();

  User? get currentUser => dataSource.currentUser;
}
