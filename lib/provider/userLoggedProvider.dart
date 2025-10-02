import 'package:divipay/domain/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLogged = StateProvider<User?> ((ref) => null);
