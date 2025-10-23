import 'package:divipay/core/components/dialogs/delete_spent_dialog.dart';
import 'package:divipay/provider/groups_provider.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

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
                      final spentMembers = ref
                          .watch(userServiceProvider)
                          .getUsersByIdList(spent.members);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            width: 0.3,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Descripción y monto
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    spent.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    Text(
                                      "\$${spent.amount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        DeleteSpentDialog.show(
                                          context,
                                          spent,
                                          groupId,
                                        );
                                      },
                                      child: const HeroIcon(HeroIcons.trash),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Divider(color: Colors.grey.shade300, thickness: 1),
                            const SizedBox(height: 8),

                            const Text(
                              "Involucrados:",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),

                            FutureBuilder(
                              future: spentMembers,
                              builder: (context, membersSnapshot) {
                                if (membersSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                } else if (membersSnapshot.hasError) {
                                  return const Text("Error al cargar los usuarios");
                                } else if (!membersSnapshot.hasData || (membersSnapshot.data as List).isEmpty) {
                                  return const Text("Sin usuarios");
                                }
                                final members = membersSnapshot.data as List;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: members.map<Widget>((user) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          user.username,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
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
