import 'package:divipay/domain/Spent.dart';

class SpentRepo {
  static List<Spent> spents = [];

  static Spent addSpent(
    String description,
    double amount,
    int userId,
    int groupId,
    List<int> members,
  ) {
    final newSpent = Spent(
      id: spents.length + 1,
      description: description,
      amount: amount,
      userId: userId,
      groupId: groupId,
      members: members,
    );

    spents.add(newSpent);
    return newSpent;
  }

  static getSpents() {
    return spents;
  }

  static removeSpent(int id) {}
}
