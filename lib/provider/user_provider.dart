import 'package:divipay/datasource/user_datasource.dart';
import 'package:divipay/repository/user_repo.dart';
import 'package:divipay/service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataSourceProvider =
    Provider((ref) => UserDatasource());
final userRepositoryProvider =
    Provider((ref) => UserRepo(ref.watch(userDataSourceProvider)));
final userServiceProvider =
    Provider((ref) => UserService(ref.watch(userRepositoryProvider)));

final incomingFriendRequestsProvider =
    StreamProvider((ref) {
  final userService = ref.watch(userServiceProvider);
  return userService.getFriendRequests();
});