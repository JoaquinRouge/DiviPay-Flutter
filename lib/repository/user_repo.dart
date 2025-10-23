import 'package:divipay/datasource/user_datasource.dart';
import 'package:divipay/domain/User.dart';

class UserRepo {
  final UserDatasource datasource;

  UserRepo(this.datasource);

  Future<User?> getById(String id) async {
    return await datasource.getById(id);
  }

  Future<List<User>?> getUsersByIdList(List<String> ids) async {
    return await datasource.getUsersByIdList(ids);
  }

  Future<List<User>?> searchUsersByName(String query) async {
    return await datasource.searchUsersByName(query);
  }

  Future<void> sendFriendRequest(String toUserId) async {
    return await datasource.sendFriendRequest(toUserId);
  }

  Future<void> acceptFriendRequest(String requestUid) async {
    return await datasource.acceptFriendRequest(requestUid);
  }
}
