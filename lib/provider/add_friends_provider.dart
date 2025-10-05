import 'package:divipay/domain/User.dart';
import 'package:divipay/repository/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriendsNotifier extends StateNotifier<List<User>> {
  AddFriendsNotifier() : super(UserRepo.getUsers());

  void filterUsers(List<User> users) {
    final ids = users.map((u) => u.id).toSet();
    state = state.where((u) => !ids.contains(u.id)).toList();
  }
}

final addFriendsProvider =
    StateNotifierProvider<AddFriendsNotifier, List<User>>((ref) {
  return AddFriendsNotifier();
});

