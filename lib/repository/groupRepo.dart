import 'package:divipay/domain/Group.dart';

class GroupRepo {
  static List<Group> groups = [
    Group(
      id: 1,
      name: "Group 1",
      description: "This is the first group",
      balance: 100.0,
    ),
    Group(
      id: 2,
      name: "Group 2",
      description: "This is the second group",
      balance: 200.0,
    ),
  ];

  static List<Group> getGroups() {
    return groups;
  }

  static addGroup(String name,String description) {
    groups.add(Group(id: groups.length + 1, name: name, description: description, balance: 0));
  }
}
