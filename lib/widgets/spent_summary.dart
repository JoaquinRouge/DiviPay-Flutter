import 'package:divipay/core/components/debt.dart';
import 'package:divipay/provider/groups_provider.dart';
import 'package:divipay/provider/user_provider.dart';
import 'package:divipay/service/debt_service.dart';
import 'package:divipay/widgets/spents_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpentSummary extends ConsumerWidget {
  final String groupId;

  const SpentSummary({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spentsFuture = ref.watch(groupServiceProvider).getSpents(groupId);
    final userProvider = ref.watch(userServiceProvider);
    return FutureBuilder(
      future: spentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los gastos"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No hay datos de gastos"));
        }

        final spents = snapshot.data;
        final simplifiedDebts = DebtService.calculateSimplifiedDebts(
          spents ?? []
        );

        final List<Widget> debtWidgets = [];
        simplifiedDebts.forEach((debtorId, creditorMap) {
          creditorMap.forEach((creditorId, amount) {
            debtWidgets.add(
              FutureBuilder(
                future: Future.wait([
                  userProvider.getUsersByIdList([creditorId]),
                  userProvider.getUsersByIdList([debtorId]),
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final creditorList = snapshot.data![0];
                  final debtorList = snapshot.data![1];

                  final creditor = creditorList?.isNotEmpty == true
                      ? creditorList!.first
                      : null;
                  final debtor = debtorList?.isNotEmpty == true
                      ? debtorList!.first
                      : null;

                  return Debt(
                    cobrador: creditor?.username ?? "Desconocido",
                    deudor: debtor?.username ?? "Desconocido",
                    monto: double.parse(amount.toStringAsFixed(2)),
                  );
                },
              ),
            );
            debtWidgets.add(const SizedBox(height: 12));
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
                offset: const Offset(0, 4),
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
                  children: const [
                    Text("Resumen de gastos"),
                    Icon(Icons.info_outline),
                  ],
                ),
                const Divider(thickness: 1),
                if (debtWidgets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Text("No hay deudas pendientes"),
                  )
                else
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
                      SpentsModal.show(context, groupId);
                    },
                    child: const Text("Ver Resumen de Gastos"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
