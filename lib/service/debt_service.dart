import 'package:divipay/core/domain/Spent.dart';

class DebtService {
  /// Calcula las deudas simplificadas dentro de un grupo.
  /// Incluye siempre al usuario que creó el gasto (payerId) en la división del monto.
  static Map<String, Map<String, double>> calculateSimplifiedDebts(List<Spent> groupSpents) {
    final Map<String, Map<String, double>> debts = {};

    // Calcular cuánto debe cada participante al pagador de cada gasto
    for (var spent in groupSpents) {
      final payerId = spent.userId;

      // Agregamos al payer a la lista de participantes si no está
      final participants = {...spent.members, payerId}.toList();

      final share = spent.amount / participants.length;

      for (var memberId in participants) {
        if (memberId == payerId) continue; // El pagador no se debe a sí mismo

        debts.putIfAbsent(memberId, () => {});
        debts[memberId]!.update(
          payerId,
          (value) => value + share,
          ifAbsent: () => share,
        );
      }
    }

    // Simplificar las deudas (A le debe a B y B a A se compensan)
    final Map<String, Map<String, double>> simplifiedDebts = {};

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
