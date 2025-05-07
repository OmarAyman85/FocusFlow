class UserModel {
  final String uid;
  final String email;
  final String name;
  final String password;
  final String photoUrl;

  UserModel({
    this.uid = '',
    required this.email,
    required this.name,
    required this.password,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'password': password,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
      photoUrl: map['photoUrl'],
    );
  }

  @override
  String toString() {
    return 'UserModel{email: $email, password: $password, name: $name, photoUrl: $photoUrl}';
  }
}
