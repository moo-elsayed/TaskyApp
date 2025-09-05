class UserModel {
  final String? name;
  final String email;
  final String? password;
  final bool isVerified;

  UserModel({
    this.name,
    required this.email,
    this.password,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    password: json['password'],
    isVerified: json['isVerified'] == true,
  );

  Map<String, dynamic> toJson() => {
    'name': ?name,
    'email': email,
    'password': ?password,
    'isVerified': isVerified,
  };
}
