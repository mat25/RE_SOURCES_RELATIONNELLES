import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfilHeader extends StatelessWidget {
  final User? user;

  const ProfilHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.deepPurple),
          ),
          const SizedBox(height: 10),
          Text(
            user?.username ?? 'Utilisateur',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            user?.email ?? '',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
