class Spent {
  Spent({
    required this.id,
    required this.description,
    required this.amount,
    required this.userId,
    required this.groupId,
    required this.members
  });

  int id;
  String description;
  double amount;
  int userId;
  int groupId;
  List<int> members;
}
