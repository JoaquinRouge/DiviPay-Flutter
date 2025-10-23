import 'package:divipay/datasource/group_datasource.dart';
import 'package:divipay/repository/group_repo.dart';
import 'package:divipay/service/group_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupDataSourceProvider = Provider((ref) => GroupDatasource());
final groupRepositoryProvider = Provider(
  (ref) => GroupRepo(ref.watch(groupDataSourceProvider)),
);
final groupServiceProvider = Provider(
  (ref) => GroupService(ref.watch(groupRepositoryProvider)),
);

final spentsProvider = FutureProvider.family((ref, String groupId) {
  final groupService = ref.watch(groupServiceProvider);
  print("HACIENDO EL LLAMADO!!!");
  return groupService.getSpents(groupId);
});
