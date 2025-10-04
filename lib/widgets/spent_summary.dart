import 'package:divipay/core/components/debt.dart';
import 'package:divipay/service/debt_service.dart';
import 'package:divipay/widgets/spents_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:divipay/repository/userRepo.dart';
import 'package:divipay/provider/spentProvider.dart';

class SpentSummary extends ConsumerWidget {
  final int groupId;

  const SpentSummary({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spentsAsync = ref.watch(spentsProvider);

    return spentsAsync.when(
      data: (spents) {
        final simplifiedDebts =
            DebtService.calculateSimplifiedDebts(spents, groupId);

        final List<Widget> debtWidgets = [];
        simplifiedDebts.forEach((debtorId, creditorMap) {
          final debtor = UserRepo.getUsersByIdList([debtorId]).first;
          creditorMap.forEach((creditorId, amount) {
            final creditor = UserRepo.getUsersByIdList([creditorId]).first;
            debtWidgets.add(
              Debt(
                cobrador: creditor.fullName,
                deudor: debtor.fullName,
                monto: double.parse(amount.toStringAsFixed(2)),
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          const Center(child: Text("Error al cargar los gastos")),
    );
  }
}
