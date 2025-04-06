class UserModel {
  final String username;
  final String email;
  final String phone;
  final String address;
  final String uid;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.uid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
