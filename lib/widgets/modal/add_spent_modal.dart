import 'package:divipay/core/components/user_selectable_tile.dart';
import 'package:divipay/domain/Spent.dart';
import 'package:divipay/provider/groups_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class AddSpentModal extends ConsumerStatefulWidget {
  const AddSpentModal({Key? key, required this.members, required this.groupId})
    : super(key: key);

  final List<String> members;
  final String groupId;

  @override
  ConsumerState<AddSpentModal> createState() => _AddSpentModalState();
}

class _AddSpentModalState extends ConsumerState<AddSpentModal> {
  late TextEditingController nameController;
  late TextEditingController amountController;

  bool isSelectAllActive = false;
  late List<bool> selected;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    amountController = TextEditingController();
    selected = List.generate(widget.members.length, (_) => false);
  }

  // Si el padre cambia la lista de miembros (ej: actualización), reajustamos el array de selected.
  @override
  void didUpdateWidget(covariant AddSpentModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.members.length != widget.members.length) {
      selected = List.generate(widget.members.length, (_) => false);
      isSelectAllActive = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = ref.watch(groupServiceProvider);

    final members = widget.members.where(
      (id) => id != FirebaseAuth.instance.currentUser?.uid,
    ).toList();

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
            Column(
              children: members.isNotEmpty
                  ? [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Descripción del gasto",
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
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
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: "Monto",
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
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
                              setState(() {
                                final newValue = !isSelectAllActive;
                                isSelectAllActive = newValue;
                                for (int i = 0; i < selected.length; i++) {
                                  selected[i] = newValue;
                                }
                              });
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
                            userId: members[index],
                            isSelected: selected[index],
                            onTap: () {
                              setState(() {
                                selected[index] = !selected[index];
                                isSelectAllActive = selected.every(
                                  (e) => e == true,
                                );
                              });
                            },
                          );
                        },
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
                            final selectedMemberIds = <String>[];
                            final description = nameController.text.trim();
                            final amountText = amountController.text.trim();
                            final amount = double.tryParse(amountText) ?? 0.0;

                            if (description.isEmpty || amountText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Los campos deben estar completos",
                                  ),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            if (amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "El monto debe ser mayor que 0",
                                  ),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            for (int i = 0; i < members.length; i++) {
                              if (selected[i]) {
                                selectedMemberIds.add(members[i]);
                              }
                            }

                            if (selectedMemberIds.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "No se puede crear un gasto sin miembros involucrados.",
                                  ),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            Spent newSpent = Spent(
                              description: description,
                              amount: amount,
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              groupId: widget.groupId,
                              members: selectedMemberIds,
                              date: DateTime.now(),
                            );

                            groupProvider.addSpent(widget.groupId, newSpent);

                            ref.invalidate(groupServiceProvider);

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
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Agregar Gasto",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ]
                  : [
                      Text(
                        "No hay miembros suficientes en el grupo",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Agrega amigos al grupo para poder registrar gastos juntos.",
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
