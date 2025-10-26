import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: const Text(
        "Cerrar Sesión",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "¿Estás seguro que querés cerrar sesión?",
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      actions: [
        Column(
          children: [
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 176, 49, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  context.go("/login");
                },
                child: const Text("Confirmar", style: TextStyle(fontSize: 15)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey, width: 1),
                ),
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Future<dynamic> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return LogoutDialog();
      },
    );
  }
}
