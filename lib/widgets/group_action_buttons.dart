import 'package:divipay/core/components/dialogs/delete_group_dialog.dart';
import 'package:divipay/core/components/dialogs/leave_group_dialog.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/widgets/add_friends_modal.dart';
import 'package:divipay/widgets/add_spent_modal.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class GroupActionButtons extends StatelessWidget {
  const GroupActionButtons({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: Colors.white, // borde
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return AddSpentModal(
                        members: group.members,
                        groupId: group.id,
                      );
                    },
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
        SizedBox(height: 10),
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
        SizedBox(height: 10),
        SizedBox(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
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
