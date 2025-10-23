import 'package:divipay/domain/Spent.dart';

class Group {
  Group({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.spents,
    required this.members,
    required this.createdAt,
  });

  String id;
  String ownerId;
  String name;
  String description;
  List<Spent> spents;
  List<String> members;
  String createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'spents': spents,
      'members': members,
      'createdAt': createdAt,
    };
  }

factory Group.fromMap(String id, Map<String, dynamic> map) {
  return Group(
    id: id,
    ownerId: map['ownerId'] ?? '',
    name: map['name'] ?? '',
    description: map['description'] ?? '',
    spents: (map['spents'] as List<dynamic>? ?? []).map((e) => Spent.fromMap(e)).toList(),
    members: (map['members'] as List<dynamic>? ?? []).cast<String>(),
    createdAt: map['createdAt'] ?? '',
  );
}

}
