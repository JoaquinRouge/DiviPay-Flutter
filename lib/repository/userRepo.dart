import 'package:divipay/domain/User.dart';

class UserRepo {
  static List<User> users = [
    User(id: 1, email: "joarouge@gmail.com", fullName: "Joaquin Rouge Nuñez"),
    User(id: 2, email: "mariana@gmail.com", fullName: "Mariana Perez Arguello"),
    User(id: 3, email: "jorge@gmail.com", fullName: "Jorge Cruz"),
    User(id: 4, email: "rodrigo@gmail.com", fullName: "Rodrigo Avalos"),
  ];

  static List<User> getUsers() {
    return users;
  }

  static List<User> getUsersByIdList(List<int> ids) {
    List<User> usersMatch = [];

    for (var user in users) {
      if (ids.contains(user.id)) {
        usersMatch.add(user);
      }
    }

    return usersMatch;
  }
}
