import 'package:divipay/core/components/userSelectableTile.dart';
import 'package:divipay/domain/User.dart';
import 'package:divipay/provider/addFriendsProvider.dart';
import 'package:divipay/provider/groupsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:go_router/go_router.dart';

class AddFriendsModal extends ConsumerStatefulWidget {
  final List<User> members;
  final int groupId;

  const AddFriendsModal({super.key, required this.members, required this.groupId});

  @override
  AddFriendsModalState createState() => AddFriendsModalState();

  /// Método estático para abrir el modal
  static Future<dynamic> show(BuildContext context, List<User> members, int groupId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return AddFriendsModal(members: members, groupId: groupId);
      },
    );
  }
}

class AddFriendsModalState extends ConsumerState<AddFriendsModal> {
  late List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    // Inicializamos el provider solo una vez al abrir el modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addFriendsProvider.notifier).filterUsers(widget.members);
      setState(() {
        selected = List.generate(ref.read(addFriendsProvider).length, (_) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final addFriendsList = ref.watch(addFriendsProvider);

    // En caso de que el provider todavía no esté inicializado
    selected = selected.length == addFriendsList.length ? selected : List.generate(addFriendsList.length, (_) => false);

    return Padding(
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: HeroIcon(
                  HeroIcons.chevronDown,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
            ),
            Column(
              children: addFriendsList.isNotEmpty
                  ? [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: addFriendsList.length,
                        itemBuilder: (context, index) {
                          return UserSelectableTile(
                            user: addFriendsList[index],
                            isSelected: selected[index],
                            onTap: () {
                              setState(() {
                                selected[index] = !selected[index];
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
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
                            final selectedUsers = <User>[];
                            for (int i = 0; i < addFriendsList.length; i++) {
                              if (selected[i]) selectedUsers.add(addFriendsList[i]);
                            }

                            ref.read(groupsProvider.notifier).addMembers(
                                  widget.groupId,
                                  selectedUsers,
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Miembros agregados correctamente"),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );

                            context.pop();
                          },
                          child: const Text("Añadir", style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ]
                  : [
                      Text(
                        "Nada que hacer por aquí...",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
