import 'package:divipay/domain/User.dart';
import 'package:divipay/repository/user_repo.dart';

class UserService {
  final UserRepo userRepository;

  UserService(this.userRepository);

  Future<User?> getById(String id) async {
    return await userRepository.getById(id);
  }

  Future<List<User>?> getUsersByIdList(List<String> ids) async {
    return await userRepository.getUsersByIdList(ids);
  }

  Future<List<User>?> searchUsersNyName(String query) async {
    return await userRepository.searchUsersByName(query);
  }

  Future<void> sendFriendRequest(String toUserId) async {
    return await userRepository.sendFriendRequest(toUserId);
  }

  Future<void> acceptFriendRequest(String requestUid) async {
    return await userRepository.acceptFriendRequest(requestUid);
  }
}