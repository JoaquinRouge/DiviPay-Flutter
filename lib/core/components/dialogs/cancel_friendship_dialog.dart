import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CancelFriendshipDialog extends ConsumerWidget {
  const CancelFriendshipDialog({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: const Text(
        "Cancelar Amistad",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "¿Estás seguro que querés cancelar esta amistad? La repartija de gastos en los grupos que tengan relacionados se perdera.",
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
                  await ref.read(userServiceProvider).cancelFriendship(userId);
                  context.pop();
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Amistad cancelada correctamente'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(
                        16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
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

  static Future<dynamic> show(BuildContext context, String userId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CancelFriendshipDialog(userId: userId);
      },
    );
  }
}
