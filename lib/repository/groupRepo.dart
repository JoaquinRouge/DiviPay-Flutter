import 'package:divipay/domain/Group.dart';
import 'package:divipay/domain/User.dart';

class GroupRepo {
  static List<Group> groups = [
    Group(
      id: 1,
      name: "Vacaciones en la playa",
      description:
          "Un viaje inolvidable para disfrutar del sol y el mar con los mejores amigos. Planificando gastos de alojamiento, comida, transporte y actividades.",
      balance: 0,
      members: [],
      createdAt: "13 de Abril de 2025",
    ),
  ];

  static List<Group> getGroups() {
    return groups;
  }

  static addGroup(String name, String description, String createdAt) {
    groups.add(
      Group(
        id: groups.length + 1,
        name: name,
        description: description,
        balance: 0,
        members: [],
        createdAt: createdAt,
      ),
    );
  }

  static addMember(int groupId, List<User> users) {
    final group = groups.firstWhere((g) => g.id == groupId);

    for (User u in users) {
      group.members.add(u);
    }
  }

  static deleteGroup(int groupId) {
    groups.removeWhere((group) => group.id == groupId);
  }
}
