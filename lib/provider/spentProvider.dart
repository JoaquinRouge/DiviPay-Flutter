import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:divipay/domain/Spent.dart';
import 'package:divipay/repository/spentRepo.dart';

class SpentsNotifier extends AsyncNotifier<List<Spent>> {
  @override
  Future<List<Spent>> build() async {
    // Estado inicial: toda la lista del repo
    return SpentRepo.getSpents();
  }

  Future<void> addSpent(
    String description,
    double amount,
    int userId,
    int groupId,
    List<int> members,
  ) async {
    // Agregar en repo
    SpentRepo.addSpent(description, amount, userId, groupId, members);

    // Refrescar estado desde repo
    state = AsyncValue.data(SpentRepo.getSpents());
  }

  List<Spent> getSpentsByGroup(int groupId) {
    final current = state.value ?? [];
    return current.where((s) => s.groupId == groupId).toList();
  }

  double getTotalAmountForGroupId(int groupId) {
    double amount = 0;

    for (Spent spent in getSpentsByGroup(groupId)) {
      amount += spent.amount;
    }

    return amount;
  }

  Future<void> removeSpent(int id) async {
    // Eliminar en repo
    SpentRepo.removeSpent(id);

    // Refrescar estado desde repo
    state = AsyncValue.data(SpentRepo.getSpents());
  }
}

// Provider global
final spentsProvider = AsyncNotifierProvider<SpentsNotifier, List<Spent>>(
  SpentsNotifier.new,
);
