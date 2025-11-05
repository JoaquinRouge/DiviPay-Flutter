import 'package:divipay/core/domain/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriendsNotifier extends StateNotifier<List<User>> {
  AddFriendsNotifier() : super([]);

  void filterUsers(List<String> users) {
    final ids = users.map((u) => u).toSet();
    state = state.where((u) => !ids.contains(u.id)).toList();
  }
}

final addFriendsProvider =
    StateNotifierProvider<AddFriendsNotifier, List<User>>((ref) {
  return AddFriendsNotifier();
});

