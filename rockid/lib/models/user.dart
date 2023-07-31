class User {
  final String uid;
  final String username;

  User({
    required this.uid,
    required this.username,
  });

  factory User.fromFirestore(Map<String, dynamic>? data) {
    if (data != null) {
      return User(
        uid: data['UID'] ?? '',
        username: data['username'] ?? '',
      );
    } else {
      return User(
        uid: '',
        username: '',
      );
    }
  }
}
