class Spent {
  Spent({
    required this.description,
    required this.amount,
    required this.userId,
    required this.groupId,
    required this.members
  });

  String description;
  double amount;
  String userId;
  String groupId;
  List<String> members;

  factory Spent.fromMap(Map<String, dynamic> map) {
    return Spent(
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      userId: map['userId'] as String,
      groupId: map['groupId'] as String,
      members: List<String>.from(map['members'] as List),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'userId': userId,
      'groupId': groupId,
      'members': members,
    };
  }
}
