import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/domain/User.dart';
import 'package:divipay/provider/spentProvider.dart';
import 'package:divipay/provider/userLoggedProvider.dart';
import 'package:divipay/repository/groupRepo.dart';
import 'package:divipay/repository/userRepo.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

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
              groupInfo(),
              SizedBox(height: 10),
              spentSummary(context, ref, widget.group.id),
              SizedBox(height: 25),
              actionButtons(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Column actionButtons(BuildContext context) {
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
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroIcon(HeroIcons.userPlus, size: 30),
                SizedBox(width: 10),
                Text("Anadir amigo", style: TextStyle(fontSize: 15)),
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
                    widget.group.members.length,
                    (_) => false,
                  );

                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      bool isSelectAllActive = selected.every((e) => e);

                      return addSpentModalContent(
                        context,
                        widget.group.members,
                        selected,
                        nameController,
                        amountController,
                        setModalState,
                        isSelectAllActive,
                        (bool newVal) {
                          setModalState(() {
                            isSelectAllActive = newVal;
                            for (int i = 0; i < selected.length; i++) {
                              selected[i] = newVal;
                            }
                          });
                        },
                      );
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
              foregroundColor: Colors.white, // borde
            ),
            onPressed: () {
              deleteGroupConfirmation(context);
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
                    onSelectAllChanged(newValue); // 👈 usa el callback
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
                return CheckboxListTile(
                  title: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      members[index].fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  value: selected[index],
                  onChanged: (value) {
                    setModalState(() {
                      selected[index] = value ?? false;

                      // Actualizar el "select all" según el estado de los checkboxes
                      isSelectAllActive = selected.every(
                        (element) => element == true,
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

  Future<dynamic> deleteGroupConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // bordes redondeados
          ),
          backgroundColor: Colors.white, // color de fondo
          title: Text(
            "Eliminar Grupo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "¿Estás seguro que querés eliminar este grupo? Esta accion es irreversible.",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          actions: [
            Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 176, 49, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.white, // borde
                    ),
                    onPressed: () {
                      GroupRepo.deleteGroup(widget.group.id);
                      context.go("/home");
                    },
                    child: Text("Confirmar", style: TextStyle(fontSize: 15)),
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
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ), // borde
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget spentSummary(BuildContext context, WidgetRef ref, int groupId) {
    final spentsAsync = ref.watch(spentsProvider);

    return spentsAsync.when(
      data: (spents) {
        final groupSpents = spents.where((s) => s.groupId == groupId).toList();

        // Mapa: deudor -> acreedor -> monto
        final Map<int, Map<int, double>> debts = {};

        for (var spent in groupSpents) {
          final payerId = spent.userId;
          final participants = spent.members;
          final share = spent.amount / participants.length;

          for (var memberId in participants) {
            if (memberId == payerId) continue;

            debts.putIfAbsent(memberId, () => {});
            debts[memberId]!.update(
              payerId,
              (value) => value + share,
              ifAbsent: () => share,
            );
          }
        }

        // 🔹 Normalización de deudas
        final Map<int, Map<int, double>> simplifiedDebts = {};

        debts.forEach((debtorId, creditorMap) {
          creditorMap.forEach((creditorId, amount) {
            final opposite = debts[creditorId]?[debtorId] ?? 0.0;
            final net = amount - opposite;

            if (net > 0) {
              simplifiedDebts.putIfAbsent(debtorId, () => {});
              simplifiedDebts[debtorId]![creditorId] = net;
            }
          });
        });

        // 🔹 Generación de widgets
        List<Widget> debtWidgets = [];
        simplifiedDebts.forEach((debtorId, creditorMap) {
          final debtor = UserRepo.getUsersByIdList([debtorId]).first;
          creditorMap.forEach((creditorId, amount) {
            final creditor = UserRepo.getUsersByIdList([creditorId]).first;
            debtWidgets.add(
              debt(
                debtor.fullName,
                creditor.fullName,
                double.parse(amount.toStringAsFixed(2)), // redondeo
              ),
            );
          });
        });

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Resumen de gastos"),
                    const Icon(Icons.info_outline),
                  ],
                ),
                const Divider(thickness: 1),
                if (debtWidgets.isEmpty) const Text("No hay deudas pendientes"),
                ...debtWidgets,
                const SizedBox(height: 10),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    onPressed: () {
                      viewSpentsModalContent(context, ref);
                    },
                    child: const Text("Ver Resumen de Gastos"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          const Center(child: Text("Error al cargar los gastos")),
    );
  }

  Future<dynamic> viewSpentsModalContent(BuildContext context, WidgetRef ref) {
    final spentsNotifier = ref.watch(spentsProvider.notifier);
    final groupSpents = spentsNotifier.getSpentsByGroup(widget.group.id);

    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height *
                0.6, // para que tenga scroll
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
                groupSpents.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay gastos para mostrar",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: groupSpents.length,
                          itemBuilder: (context, index) {
                            final spent = groupSpents[index];
                            final spentMembers = UserRepo.getUsersByIdList(
                              spent.members,
                            );

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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// Descripción con protección contra overflow
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

                                      /// Monto
                                      Text(
                                        "\$${spent.amount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  Divider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 8),

                                  /// Label de involucrados
                                  const Text(
                                    "Involucrados:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  /// Lista horizontal de usuarios involucrados
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: spentMembers.map((user) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            user.fullName,
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
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row debt(String deudor, String cobrador, double monto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Texto de la deuda, recortando si es muy largo
        Expanded(
          child: Text(
            "$deudor le debe a $cobrador",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: 8), // un pequeño espacio antes del monto
        Text(
          "\$${monto.toStringAsFixed(2)}",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Container groupInfo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.group.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                HeroIcon(HeroIcons.pencilSquare),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.group.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "Fecha de creación: ${widget.group.createdAt}",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 10),
            Text(
              "Cantidad de integrantes: ${widget.group.members.length}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
