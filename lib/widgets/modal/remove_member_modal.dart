import 'package:divipay/core/components/dialogs/remove_member_dialog.dart';
import 'package:divipay/domain/User.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:divipay/service/profile_picture_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class RemoveMembersModal extends ConsumerStatefulWidget {
  const RemoveMembersModal({
    Key? key,
    required this.members,
    required this.groupId,
  }) : super(key: key);

  final List<String> members;
  final String groupId;

  @override
  ConsumerState<RemoveMembersModal> createState() => _RemoveMembersModalState();
}

class _RemoveMembersModalState extends ConsumerState<RemoveMembersModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 10),
            FutureBuilder(
              future: ref
                  .read(userServiceProvider)
                  .getUsersByIdList(widget.members),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return const Text("Error al cargar usuarios");
                }

                final friends = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return friendCard(friends[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container friendCard(User u) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 233, 233, 235),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ProfilePictureService.smallPicture(
                  u.username,
                  u.profileImageUrl,
                ),
                Text(u.email),
              ],
            ),
            GestureDetector(
              onTap: () {
                RemoveMemberDialog.show(context, u.id, widget.groupId);
              },
              child: HeroIcon(HeroIcons.xMark),
            ),
          ],
        ),
      ),
    );
  }
}
