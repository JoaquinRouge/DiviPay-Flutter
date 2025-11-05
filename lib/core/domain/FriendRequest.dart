class FriendRequest {
  FriendRequest({required this.uid,required this.from, required this.to, required this.status});

  String uid;
  String from;
  String to;
  String status;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'from': from,
      'to': to,
      'status': status,
    };
  }

  factory FriendRequest.fromMap(String id, Map<String, dynamic> map) {
    return FriendRequest(
      uid: id,
      from: map['from'],
      to: map['to'],
      status: map['status'],
    );
  }
}
