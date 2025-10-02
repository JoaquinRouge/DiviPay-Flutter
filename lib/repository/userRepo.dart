import 'package:divipay/domain/User.dart';

class UserRepo {
  static List<User> users = [
    User(id: 1, email: "joarouge@gmail.com", fullName: "Joaquin Rouge Nuñez",password: "1234"),
    User(id: 2, email: "mariana@gmail.com", fullName: "Mariana Perez Arguello",password: "1234"),
    User(id: 3, email: "jorge@gmail.com", fullName: "Jorge Cruz",password: "1234"),
    User(id: 4, email: "rodrigo@gmail.com", fullName: "Rodrigo Avalos",password: "1234"),
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

  static bool login(String email, String password) {
    final user = users.firstWhere(
      (user) => user.email == email,
      orElse: () => User(id: -1, email: "notFound", fullName: "notFound",password: "notFound"),
    );

    return user.email == email && user.password == password;
  }

  static User findUser(String email){
    return users.firstWhere((u) => u.email == email);
  }
}
