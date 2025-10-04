import 'package:divipay/domain/Spent.dart';

class DebtService {
  static Map<int, Map<int, double>> calculateSimplifiedDebts(List<Spent> spents, int groupId) {
    final groupSpents = spents.where((s) => s.groupId == groupId).toList();
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

    return simplifiedDebts;
  }
}
