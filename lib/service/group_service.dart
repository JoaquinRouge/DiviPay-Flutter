import 'package:divipay/core/domain/Group.dart';
import 'package:divipay/core/domain/Spent.dart';
import 'package:divipay/repository/group_repo.dart';

class GroupService {
  final GroupRepo repository;

  GroupService(this.repository);

  Stream<Group?> getById(String id) {
    return repository.getById(id);
  }

  Future<List<Group?>> getAll(String userId) async {
    return await repository.getGroups(userId);
  }

  Future<void> createGroup(String name, String description) async {

    if(name.isEmpty || description.isEmpty){
      throw Exception("Por favor, completa todos los campos.");
    }

    await repository.createGroup(name,description);
  }

  Future<void> updateGroup(String id, String name, String description) async {
    await repository.updateGroup(id,name,description);  
  }

  Future<void> addMembers(String groupId, List<String> members) async {
    await repository.addMembers(groupId,members);
  }

  Future<void> addSpent(String groupId, Spent spent) async {
    await repository.addSpent(groupId,spent);
  }

  Future<void> deleteSpent(String groupId, Spent spent) async {
    await repository.deleteSpent(groupId, spent);
  }

  Future<List<Spent>?> getSpents(String groupId) async {
    return await repository.getSpents(groupId);
  } 

  Future<void> removeMember(String userId,String groupId) async {
    await repository.removeMember(userId,groupId);
  }

  Future<void> updateOwner(String groupId, String newOwnerId) async {
    await repository.updateOwner(groupId,newOwnerId);
  }

  Future<double?> getTotal(String groupId) async {
    return await repository.getTotal(groupId);
  }

  Future<void> deleteGroup(String groupId) async {
    await repository.deleteGroup(groupId);
  }
}
