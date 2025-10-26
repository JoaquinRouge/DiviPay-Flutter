import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divipay/domain/FriendRequest.dart';
import 'package:divipay/domain/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class UserDatasource {
  final firebaseInstance = FirebaseFirestore.instance;
  final firebaseUsers = FirebaseFirestore.instance.collection('users');

  Future<User?> getById(String id) async {
    final doc = await firebaseUsers.doc(id).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!);
    }
    return null;
  }

  Future<List<User>?> getUsersByIdList(List<String> ids) async {
    final querySnapshot = await firebaseUsers
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return querySnapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
  }

  Future<List<User>> searchUsersByName(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final currentUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    final querySnapshot = await firebaseUsers
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final List<String?> blackList = await getFriendsIds();

    blackList.add(currentUid);

    return querySnapshot.docs
        .map((doc) => User.fromMap(doc.data()))
        .where((user) => !blackList.contains(user.id))
        .toList();
  }

  Future<void> sendFriendRequest(String toUserId) async {
    final fromUserId = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    await firebaseInstance.collection('friend_requests').add({
      'from': fromUserId,
      'to': toUserId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFriendRequest(String requestUid) async {
    await firebaseInstance.collection('friend_requests').doc(requestUid).update(
      {'status': 'accepted'},
    );

    final requesterId =
        (await firebaseInstance
                .collection('friend_requests')
                .doc(requestUid)
                .get())
            .data()?['from'];

    await firebaseInstance.collection('friends').add({
      'friends': [requesterId, fb_auth.FirebaseAuth.instance.currentUser?.uid],
      'since': FieldValue.serverTimestamp(),
    });
  }

  Future<void> declineFriendRequest(String requestUid) async {
    await firebaseInstance.collection('friend_requests').doc(requestUid).update(
      {'status': 'declined'},
    );
  }

  Future<bool> requestPending(String userId) async {
    final currentUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    final sentQuery = await firebaseInstance
        .collection('friend_requests')
        .where('from', isEqualTo: currentUid)
        .where('to', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    final receivedQuery = await firebaseInstance
        .collection('friend_requests')
        .where('from', isEqualTo: userId)
        .where('to', isEqualTo: currentUid)
        .where('status', isEqualTo: 'pending')
        .get();

    return sentQuery.docs.isNotEmpty || receivedQuery.docs.isNotEmpty;
  }

  Stream<List<FriendRequest>> getFriendRequests() {
    final currentUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    return firebaseInstance
        .collection('friend_requests')
        .where('status', isEqualTo: 'pending')
        .where('to', isEqualTo: currentUid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FriendRequest.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Future<List<String>> getFriendsIds() async {
    final userId = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    final friendsIds = <String>[];

    final snapshot = await firebaseInstance
        .collection('friends')
        .where('friends', arrayContains: userId)
        .get();

    for (final doc in snapshot.docs) {
      final friendsList = List<String>.from(doc['friends']);

      for (final id in friendsList) {
        if (id != userId && !friendsIds.contains(id)) {
          friendsIds.add(id);
        }
      }
    }

    return friendsIds;
  }

  Future<void> changeUsername(String newUsername) async {
    final currentUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    final searchUsers = await firebaseUsers
        .where('username', isEqualTo: newUsername)
        .get();

    final usernameTaken = searchUsers.docs;

    if (usernameTaken.isNotEmpty) {
      throw Exception("El nombre de usuario ya esta en uso.");
    }

    await firebaseUsers.doc(currentUid).update({'username': newUsername});
  }

  Future<void> changePassword(String newPassword) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }
}
