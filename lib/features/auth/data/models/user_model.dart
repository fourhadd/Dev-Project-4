import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  factory UserModel.fromEntity(User user) =>
      UserModel(id: user.id, name: user.name, email: user.email);

  User toEntity() => User(id: id, name: name, email: email);
}
