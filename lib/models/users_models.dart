class UserModel {
  final String uid;
  final String userName;
  final String email;
  final String password;
  final String profilePic;
  final int netPoints;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.netPoints,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'password': password,
      'profilePic': profilePic,
      'netPoints': netPoints,
    };
  }

  // Create a UserModel instance from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
      netPoints: map['netPoints'] ?? 0,
    );
  }
}
