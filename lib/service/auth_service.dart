import 'package:firebase_auth/firebase_auth.dart';
import 'package:divipay/repository/auth_repository.dart';

class AuthService {
  final AuthRepository repository;

  AuthService(this.repository);

  Future<User?> register(String email, String username, String password) {
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      throw Exception("Por favor, completa todos los campos.");
    }

    return repository.register(email, username, password);
  }

  Future<User?> login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Por favor, completa todos los campos.");
    }

    return repository.login(email, password);
  }

  Future<void> logout() => repository.logout();

  User? get currentUser => repository.currentUser;
}
