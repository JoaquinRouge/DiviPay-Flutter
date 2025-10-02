import 'package:divipay/domain/Group.dart';
import 'package:divipay/repository/groupRepo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsNotifier extends StateNotifier<List<Group>> {
  GroupsNotifier() : super(GroupRepo.groups);

  void deleteGroup(int id) {
    GroupRepo.deleteGroup(id);
    state = state.where((g) => g.id != id).toList();
  }
}

final groupsProvider =
    StateNotifierProvider<GroupsNotifier, List<Group>>((ref) {
  return GroupsNotifier();
});
