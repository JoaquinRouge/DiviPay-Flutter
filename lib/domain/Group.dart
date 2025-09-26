import 'package:divipay/domain/User.dart';

class Group {
  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.balance,
    required this.members,
    required this.createdAt,
  });

  int id;
  String name;
  String description;
  double balance;
  List<User> members;
  String createdAt;
}
