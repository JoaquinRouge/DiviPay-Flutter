import 'package:divipay/domain/Group.dart';
import 'package:divipay/repository/groupRepo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupsProvider = StateProvider<List<Group>>((ref) => GroupRepo.groups);