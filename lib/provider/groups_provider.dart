import 'package:divipay/domain/Group.dart';
import 'package:divipay/domain/User.dart';
import 'package:divipay/repository/group_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsNotifier extends StateNotifier<List<Group>> {
  GroupsNotifier() : super(GroupRepo.groups);

  void deleteGroup(int id) {
    GroupRepo.deleteGroup(id);
    state = state.where((g) => g.id != id).toList();
  }

  void addMembers(int groupId, List<User> users) {
    GroupRepo.addMember(groupId, users);
    state = List.from(GroupRepo.groups);
  }

  void addGroup(String name, String description) {
    GroupRepo.addGroup(name, description);
    state = List.from(GroupRepo.groups);
  }
}

final groupsProvider = StateNotifierProvider<GroupsNotifier, List<Group>>((
  ref,
) {
  return GroupsNotifier();
});
