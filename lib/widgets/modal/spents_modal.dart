import 'package:divipay/core/components/dialogs/delete_spent_dialog.dart';
import 'package:divipay/core/domain/User.dart';
import 'package:divipay/provider/groups_provider.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:divipay/service/profile_picture_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class SpentsModal extends ConsumerWidget {
  final String groupId;

  const SpentsModal({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupSpentsFuture = ref
        .watch(groupServiceProvider)
        .getSpents(groupId);

    return Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: FutureBuilder(
                future: groupSpentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error al cargar los gastos"),
                    );
                  } else if (!snapshot.hasData ||
                      (snapshot.data as List).isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay gastos para mostrar",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final groupSpents = snapshot.data as List;

                  return ListView.builder(
                    itemCount: groupSpents.length,
                    itemBuilder: (context, index) {
                      final spent = groupSpents[index];

                      final List<String> members = [spent.userId];

                      members.addAll(spent.members);

                      final spentMembers = ref
                          .watch(userServiceProvider)
                          .getUsersByIdList(members);

                      return spentCard(spent, context, spentMembers, groupId);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container spentCard(
    spent,
    BuildContext context,
    Future<List<User>?> spentMembers,
    String groupId,
  ) {
    final formattedDate = DateFormat(
      "d 'de' MMMM, yyyy",
      'es_ES',
    ).format(spent.date);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Descripción + monto + menú
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spent.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\$${spent.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      DeleteSpentDialog.show(context, spent, groupId);
                    },
                    child: HeroIcon(HeroIcons.trash),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Involucrados
          const Text(
            "Involucrados:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          FutureBuilder(
            future: spentMembers,
            builder: (context, membersSnapshot) {
              if (membersSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              } else if (membersSnapshot.hasError) {
                return const Text(
                  "Error al cargar los usuarios",
                  style: TextStyle(color: Colors.redAccent),
                );
              } else if (!membersSnapshot.hasData ||
                  (membersSnapshot.data as List).isEmpty) {
                return const Text(
                  "Sin usuarios",
                  style: TextStyle(color: Colors.black54),
                );
              }

              final members = membersSnapshot.data as List<User>;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: members.map<Widget>((user) {
                    return ProfilePictureService.smallPicture(user.username,user.profileImageUrl);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Future<dynamic> show(BuildContext context, String groupId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return SpentsModal(groupId: groupId);
      },
    );
  }
}
