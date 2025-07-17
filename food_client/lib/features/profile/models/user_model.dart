class UserModel {
  final String username;
  final String email;
  final String userImage;

  UserModel({
    required this.username,
    required this.email,
    required this.userImage,
  });

  UserModel copyWith({String? username, String? email, String? userImage}) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      userImage: userImage ?? this.userImage,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      userImage: map['userImage'] ?? '',
    );
  }

  @override
  String toString() =>
      'UserModel(username: $username, email: $email, userImage: $userImage)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.userImage == userImage;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ userImage.hashCode;
}
