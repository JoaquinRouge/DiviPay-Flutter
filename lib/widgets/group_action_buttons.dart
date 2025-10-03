import 'package:divipay/core/components/dialogs/delete_group_dialog.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/widgets/add_friends_modal.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

// 👇 Estos son propios de tu proyecto
// (asegúrate de cambiarlos si los archivos están en otra ruta)
import 'package:divipay/provider/spentProvider.dart';
import 'package:divipay/repository/userRepo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupActionButtons extends StatelessWidget {
  GroupActionButtons({super.key, required this.group});

  Group group;

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
              foregroundColor: Colors.white, // borde
            ),
            onPressed: () {
              final List<bool> selected = List.generate(
                group.members.length,
                (_) => false,
              );
              AddFriendsModal.show(context, group.members, group.id);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  final List<bool> selected = List.generate(
                    group.members.length,
                    (_) => false,
                  );

                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      bool isSelectAllActive = selected.every((e) => e);
                      return Text("data");
                      //return addSpentModalContent(
                      //  context,
                      //  widget.group.members,
                      //  selected,
                      //  nameController,
                      //  amountController,
                      //  setModalState,
                      //  isSelectAllActive,
                      //  (bool newVal) {
                      //    setModalState(() {
                      //      isSelectAllActive = newVal;
                      //      for (int i = 0; i < selected.length; i++) {
                      //        selected[i] = newVal;
                      //      }
                      //    });
                      //  },
                      // );
                    },
                  );
                },
              );
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroIcon(HeroIcons.trash, size: 30),
                SizedBox(width: 10),
                Text("Eliminar grupo", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
