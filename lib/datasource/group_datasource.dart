import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divipay/domain/Spent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:divipay/domain/Group.dart';

class GroupDatasource {
  final firebaseInstance = FirebaseFirestore.instance.collection('groups');

  Stream<Group?> getById(String id) {
    return firebaseInstance.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Group.fromMap(doc.id, doc.data()!);
      } else {
        return null;
      }
    });
  }

  Future<List<Group>> getAll(String userId) async {
    final Set<String> groupIds = {};
    final List<Group> groups = [];

    final groupsByMembers = await firebaseInstance
        .where('members', arrayContains: userId)
        .get();

    for (var doc in groupsByMembers.docs) {
      if (groupIds.add(doc.id)) {
        groups.add(Group.fromMap(doc.id, doc.data()));
      }
    }

    final groupsByOwner = await firebaseInstance
        .where('ownerId', isEqualTo: userId)
        .get();

    for (var doc in groupsByOwner.docs) {
      if (groupIds.add(doc.id)) {
        groups.add(Group.fromMap(doc.id, doc.data()));
      }
    }

    return groups;
  }

  Future<void> createGroup(String name, String description) async {
    final newGroupRef = firebaseInstance.doc();
    final user = FirebaseAuth.instance.currentUser;

    final group = Group(
      id: newGroupRef.id,
      ownerId: user!.uid,
      name: name,
      description: description,
      spents: [],
      members: [user.uid],
      createdAt: DateTime.now().toIso8601String(),
    );

    await newGroupRef.set(group.toMap());
  }

  Future<void> update(String id, String name, String description) async {
    await firebaseInstance.doc(id).update({
      'name': name,
      'description': description,
    });
  }

  Future<void> addMembers(String id, List<String> members) async {
    await firebaseInstance.doc(id).update({
      'members': FieldValue.arrayUnion(members),
    });
  }

  Future<void> addSpent(String id, Spent spent) async {
    await firebaseInstance.doc(id).update({
      'spents': FieldValue.arrayUnion([spent.toMap()]),
    });
  }

  Future<void> removeMember(String groupId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final groupRef = firebaseInstance.doc(groupId);
    final group = await groupRef.get();

    final data = group.data();

    await firebaseInstance.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });

    final updatedSnap = await groupRef.get();
    final updatedData = updatedSnap.data();

    final members = List<String>.from(updatedData?['members']);

    if (members.isEmpty) {
      await delete(groupId);
      return;
    }

    if (data?['ownerId'] == userId) {
      await firebaseInstance.doc(groupId).update({
        'ownerId': updatedData?['members'][0],
      });
    }
  }

  Future<List<Spent>?> getSpents(String groupId) async {
    final doc = await firebaseInstance.doc(groupId).get();
    if (doc.exists) {
      final data = doc.data()!;
      final spentsData = data['spents'] as List<dynamic>? ?? [];
      return spentsData.map((e) => Spent.fromMap(e)).toList();
    }
    return null;
  }

  Future<void> deleteSpent(String groupId, Spent spent) async {
    await firebaseInstance.doc(groupId).update({
      'spents': FieldValue.arrayRemove([spent.toMap()]),
    });
  }

  Future<void> updateOwner(String groupId, String newOwnerId) async {
    await firebaseInstance.doc(groupId).update({'ownerId': newOwnerId});
  }

  Future<double?> getTotal(String groupId) async {
    final doc = await firebaseInstance.doc(groupId).get();
    if (doc.exists) {
      final data = doc.data()!;
      final spentsData = data['spents'] as List<dynamic>? ?? [];
      double total = 0.0;
      for (var spentData in spentsData) {
        final spent = Spent.fromMap(spentData);
        total += spent.amount;
      }
      return total;
    }
    return null;
  }

  Future<void> delete(String id) async {
    await firebaseInstance.doc(id).delete();
  }
}
