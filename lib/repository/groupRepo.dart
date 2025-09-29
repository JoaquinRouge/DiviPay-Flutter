import 'package:divipay/domain/Group.dart';
import 'package:divipay/repository/userRepo.dart';

class GroupRepo {
  static List<Group> groups = [
    Group(
      id: 1,
      name: "Vacaciones en Mallorca",
      description:
          "Un viaje inolvidable para disfrutar del sol y el mar con los mejores amigos. Planificando gastos de alojamiento, comida, transporte y actividades.",
      balance: 100.0,
      members: UserRepo.getUsers(),
      createdAt: "13 de Abril de 2025",
    ),
    Group(
      id: 2,
      name: "Group 2",
      description: "This is the second group",
      balance: 200.0,
      members: UserRepo.getUsers(),
      createdAt: "20 de Septiembre de 2025",
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
        members: List.empty(),
        createdAt: createdAt,
      ),
    );
  }
}
