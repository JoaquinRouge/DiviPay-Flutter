import 'package:divipay/core/components/dialogs/delete_group_dialog.dart';
import 'package:divipay/core/components/dialogs/leave_group_dialog.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/widgets/modal/add_friends_modal.dart';
import 'package:divipay/widgets/modal/add_spent_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class GroupActionButtons extends ConsumerWidget {
  const GroupActionButtons({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = group.ownerId == FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        SizedBox(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              AddFriendsModal.show(context, group.members, group.id);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeroIcon(HeroIcons.userPlus, size: 30),
                SizedBox(width: 10),
                Text("Añadir amigo", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(
                        context,
                      ).viewInsets.bottom, // 👈 eleva con el teclado
                    ),

                    child: StatefulBuilder(
                      builder: (context, setModalState) {
                        return AddSpentModal(
                          members: group.members,
                          groupId: group.id,
                        );
                      },
                    ),
                  );
                },
              );
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeroIcon(HeroIcons.plusCircle, size: 30),
                SizedBox(width: 10),
                Text("Añadir gasto", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
        if (isOwner) ...[
          SizedBox(height: 10),
          SizedBox(
            width: 400,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 176, 49, 40),
                side: BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                DeleteGroupDialog.show(context, group.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeroIcon(HeroIcons.trash, size: 30),
                  SizedBox(width: 10),
                  Text("Eliminar grupo", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: 10),
        SizedBox(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              LeaveGroupDialog.show(context, group.id);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeroIcon(HeroIcons.arrowRightStartOnRectangle, size: 30),
                SizedBox(width: 10),
                Text("Abandonar grupo", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
