import 'package:dio/dio.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return User(
      id: data['id'] ?? 0,
      name: '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}',
      email: data['email'] ?? 'Non disponible',
      avatar: data['avatar'] ?? '',
    );
  }
}
