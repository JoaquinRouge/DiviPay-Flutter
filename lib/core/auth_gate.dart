import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/app_router.dart';
import '../presentation/screens/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Muestra un loader mientras verifica sesión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Usuario autenticado → muestra app con router
        if (snapshot.hasData) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: routerApp,
          );
        }

        // Usuario no autenticado → pantalla de login
        return const Login();
      },
    );
  }
}
