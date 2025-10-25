import 'package:divipay/provider/groups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LeaveGroupDialog extends ConsumerWidget {
  final String groupId;

  const LeaveGroupDialog({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: const Text(
        "Abandonar Grupo",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Deberás ser invitado nuevamente para volver a unirte. En caso de ser el propietario, tu cargo será reasignado. Si sos el último miembro, el grupo será eliminado. Esta acción no se puede deshacer.",
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
                onPressed: () async{
                  ref.read(groupServiceProvider).removeMember(groupId);
                  await Future.delayed(const Duration(milliseconds: 300));
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

  static Future<dynamic> show(BuildContext context, String groupId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return LeaveGroupDialog(groupId: groupId);
      },
    );
  }
}
