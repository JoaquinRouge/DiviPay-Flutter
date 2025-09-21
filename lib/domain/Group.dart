class Group {

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.balance,
  });

  int id;
  String name;
  String description;
  double balance;

  static getGroups() {
    return <Group>[
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
      Group(
        id: 3,
        name: "Group 3",
        description: "This is the third group",
        balance: 300.0,
      ),
    ];
  }

}
