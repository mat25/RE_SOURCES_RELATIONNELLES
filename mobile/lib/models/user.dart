class User {
  final int id;
  final String lastName;
  final String firstName;
  final String username;
  final String email;
  final String status;
  final String registrationDate;
  final Role role;

  User({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.username,
    required this.email,
    required this.status,
    required this.registrationDate,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastName: json['name'],
      firstName: json['firstName'],
      username: json['username'],
      email: json['email'],
      status: json['status'],
      registrationDate: json['registrationDate'],
      role: Role.fromJson(json['role']),
    );
  }
}

class Role {
  final int id;
  final String name;
  final String description;

  Role({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
