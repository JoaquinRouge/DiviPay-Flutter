import 'package:divipay/core/components/user_selectable_tile.dart';
import 'package:divipay/provider/add_friends_provider.dart';
import 'package:divipay/provider/groups_provider.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:go_router/go_router.dart';

class AddFriendsModal extends ConsumerStatefulWidget {
  final List<String> members;
  final String groupId;

  const AddFriendsModal({
    super.key,
    required this.members,
    required this.groupId,
  });

  @override
  AddFriendsModalState createState() => AddFriendsModalState();

  static Future<dynamic> show(
    BuildContext context,
    List<String> members,
    String groupId,
  ) {
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
  late Future<List<String>> _allFriendsFuture;

  @override
  void initState() {
    super.initState();
    _allFriendsFuture = ref.read(userServiceProvider).getFriendsIds();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addFriendsProvider.notifier).filterUsers(widget.members);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: FutureBuilder<List<String>>(
          future: _allFriendsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final allFriends = snapshot.data ?? [];

            final addFriendsList = allFriends
                .where((id) => !widget.members.contains(id))
                .toList();

            if (selected.length != addFriendsList.length) {
              selected = List.generate(addFriendsList.length, (_) => false);
            }

            return Column(
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
                if (addFriendsList.isNotEmpty)
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: addFriendsList.length,
                        itemBuilder: (context, index) {
                          return UserSelectableTile(
                            userId: addFriendsList[index],
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
                            final selectedUsers = <String>[];
                            for (int i = 0; i < addFriendsList.length; i++) {
                              if (selected[i]) selectedUsers.add(addFriendsList[i]);
                            }

                            if (selectedUsers.isNotEmpty) {
                              ref
                                  .read(groupServiceProvider)
                                  .addMembers(widget.groupId, selectedUsers);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Miembros agregados correctamente",
                                  ),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }

                            context.pop();
                          },
                          child: const Text(
                            "Añadir",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No hay amigos disponibles",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ninguno de tus amigos está disponible para agregar a este grupo.",
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

