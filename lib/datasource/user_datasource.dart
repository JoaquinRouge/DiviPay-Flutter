import 'package:cloud_firestore/cloud_firestore.dart';
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

    return querySnapshot.docs
        .map((doc) => User.fromMap(doc.data()))
        .toList();
  }

  Future<List<User>> searchUsersByName(String query) async {

    if(query.isEmpty){
      return [];
    }

    final currentUid = fb_auth.FirebaseAuth.instance.currentUser?.uid;

    final querySnapshot = await firebaseUsers
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

  return querySnapshot.docs
      .map((doc) => User.fromMap(doc.data()))
      .where((user) => user.id != currentUid)
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

    await firebaseInstance.collection('friend_requests').doc(requestUid).update({
      'status': 'accepted',
    });

    final requesterId = (await firebaseInstance.collection('friend_requests').doc(requestUid).get()).data()?['from'];

    await firebaseInstance.collection('friends').add({
      'friends': [requesterId, fb_auth.FirebaseAuth.instance.currentUser?.uid],
      'since': FieldValue.serverTimestamp(),
    });
  }

}