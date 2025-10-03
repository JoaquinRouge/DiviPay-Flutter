import 'package:divipay/provider/groupsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteGroupDialog extends ConsumerWidget {
  final int groupId;

  const DeleteGroupDialog({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: const Text(
        "Eliminar Grupo",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "¿Estás seguro que querés eliminar este grupo? Esta accion es irreversible.",
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
                onPressed: () {
                  ref.read(groupsProvider.notifier).deleteGroup(groupId);
                  context.go("/home");
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
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
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

  static Future<dynamic> show(BuildContext context, int groupId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return DeleteGroupDialog(groupId: groupId);
      },
    );
  }
}
