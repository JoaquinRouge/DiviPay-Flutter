import 'package:divipay/service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider =
    Provider((ref) => UserService());

final incomingFriendRequestsProvider =
    StreamProvider((ref) {
  final userService = ref.watch(userServiceProvider);
  return userService.getFriendRequests();
});