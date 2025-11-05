class User {
  User({required this.id, required this.username, required this.email,required this.profileImageUrl});

  String id;
  String username;
  String email;
  String profileImageUrl;

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? ''
    );
  }
}
