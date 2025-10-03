import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/core/components/userSelectableTile.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/domain/User.dart';
import 'package:divipay/provider/addFriendsProvider.dart';
import 'package:divipay/provider/groupsProvider.dart';
import 'package:divipay/provider/spentProvider.dart';
import 'package:divipay/provider/userLoggedProvider.dart';
import 'package:divipay/widgets/group_action_buttons.dart';
import 'package:divipay/widgets/spent_summary.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:divipay/widgets/group_info.dart';

class Groupdetail extends ConsumerStatefulWidget {
  const Groupdetail({super.key, required this.group});

  final Group group;

  @override
  ConsumerState<Groupdetail> createState() => _GroupdetailState();
}

class _GroupdetailState extends ConsumerState<Groupdetail> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              GroupInfo(group: widget.group,),
              SizedBox(height: 10),
              SpentSummary(groupId:widget.group.id),
              SizedBox(height: 25),
              GroupActionButtons(group: widget.group)
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget addSpentModalContent(
    BuildContext context,
    List<User> members,
    List<bool> selected,
    TextEditingController nameController,
    TextEditingController amountController,
    void Function(void Function()) setModalState,
    bool isSelectAllActive,
    void Function(bool) onSelectAllChanged,
  ) {
    final spentsNotifier = ref.watch(spentsProvider.notifier);

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
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Descripción del gasto",
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                prefixIcon: HeroIcon(
                  HeroIcons.documentText,
                  color: Theme.of(context).primaryColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Monto",
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                prefixIcon: HeroIcon(
                  HeroIcons.currencyDollar,
                  color: Theme.of(context).primaryColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              color: Colors.grey,
              thickness: .5,
              indent: 12,
              endIndent: 12,
            ),
            const SizedBox(height: 15),
            Column(
              children: members.isNotEmpty
                  ? [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Miembros involucrados",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              final newValue = !isSelectAllActive;
                              onSelectAllChanged(newValue);
                            },
                            child: isSelectAllActive
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          return UserSelectableTile(
                            user: members[index],
                            isSelected: selected[index],
                            onTap: () {
                              setModalState(() {
                                selected[index] = !selected[index];

                                isSelectAllActive = selected.every(
                                  (e) => e == true,
                                );
                              });
                            },
                          );
                        },
                      ),
                    ]
                  : [Text("No hay miembros en este grupo")],
            ),
            const SizedBox(height: 15),
            Divider(
              color: Colors.grey,
              thickness: .5,
              indent: 12,
              endIndent: 12,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final selectedMemberIds = <int>[];
                  final description = nameController.text.trim();
                  final amount =
                      double.tryParse(amountController.text.trim()) ?? 0.0;

                  if (description.isEmpty || amountController.text.isEmpty) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "No se pudo crear el grupo. Los campos deben estar completos",
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  for (int i = 0; i < members.length; i++) {
                    if (selected[i]) {
                      selectedMemberIds.add(members[i].id);
                    }
                  }

                  if (selectedMemberIds.isEmpty) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "No se puede crear un gasto sin miembros involucrados.",
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  spentsNotifier.addSpent(
                    description,
                    amount,
                    ref.read(userLogged)!.id,
                    widget.group.id,
                    selectedMemberIds,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Gasto agregado correctamente"),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );

                  nameController.clear();
                  amountController.clear();
                  context.pop();
                },
                child: const Text(
                  "Agregar Gasto",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}