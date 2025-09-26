import 'package:divipay/core/components/appBar.dart';
import 'package:divipay/domain/Group.dart';
import 'package:flutter/material.dart';
import 'package:divipay/core/components/bottomAppBar.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class Groupdetail extends StatelessWidget {
  const Groupdetail({super.key, required this.group});

  final Group group;

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
              spentSummary(context),
              SizedBox(height: 25),
              actionButtons(context)
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
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroIcon(HeroIcons.plusCircle, size: 30),
                    SizedBox(width: 10),
                    Text("Anadir gasto", style: TextStyle(fontSize: 15)),
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

  Future<dynamic> deleteGroupConfirmation(BuildContext context) {
    return showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // bordes redondeados
                        ),
                        backgroundColor: Colors.white, // color de fondo
                        title: Text(
                          "Eliminar Grupo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      176,
                                      49,
                                      40,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    foregroundColor: Colors.white, // borde
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Confirmar",
                                    style: TextStyle(fontSize: 15),
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
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
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

  Container spentSummary(BuildContext context) {
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
                Text("Resumen de gastos"),
                HeroIcon(HeroIcons.informationCircle),
              ],
            ),
            Divider(thickness: 1, indent: 0, endIndent: 0),
            debt("Alicia", "Pedro", 12324),
            debt("Mariano", "Alicia", 546),
            debt("Rodrigo", "Lautaro", 7256.24),
            debt("Lautario", "Pedro", 927),
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
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ), // borde
                ),
                onPressed: () {},
                child: Text("Ver Resumen de Gastos"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row debt(String deudor, String cobrador, double monto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$deudor le debe a $cobrador"),
        Text(
          "\$$monto",
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
                    group.name,
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
            Text(group.description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              "Fecha de creación: ${group.createdAt}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
