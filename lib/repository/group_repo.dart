import 'package:divipay/datasource/group_datasource.dart';
import 'package:divipay/domain/Group.dart';
import 'package:divipay/domain/Spent.dart';

class GroupRepo {
  final GroupDatasource groupDatasource;

  GroupRepo(this.groupDatasource);

  Future<Group?> getById(String id) async{
    return await groupDatasource.getById(id);
  }

  Future<List<Group?>> getGroups(String userId) async {
    return await groupDatasource.getAll(userId);
  }

  Future<void> createGroup(String name, String description) async {
    await groupDatasource.createGroup(name, description);
  }

  Future<void> updateGroup(String id, String name, String description) async {
    await groupDatasource.update(id, name, description);
  }

  Future<void> addMembers(String groupId, List<String> members) async {
    await groupDatasource.addMembers(groupId, members);
  }

  Future<void> addSpent(String groupId, Spent spent) async {
    await groupDatasource.addSpent(groupId, spent);
  }

  Future<List<Spent>?> getSpents(String groupId) async {
    return await groupDatasource.getSpents(groupId);
  }

  Future<void> deleteSpent(String groupId, Spent spent) async {
    await groupDatasource.deleteSpent(groupId, spent);
  }

  Future<void> removeMember(String groupId) async {
    await groupDatasource.removeMember(groupId);
  }

  Future<void> updateOwner(String groupId, String newOwnerId) async {
    await groupDatasource.updateOwner(groupId, newOwnerId);
  }

  Future<double?> getTotal(String groupId) async {
    final total = await groupDatasource.getTotal(groupId);
    return total ?? 0.0;
  }

  Future<void> deleteGroup(String groupId) async {
    await groupDatasource.delete(groupId);
  }
}
