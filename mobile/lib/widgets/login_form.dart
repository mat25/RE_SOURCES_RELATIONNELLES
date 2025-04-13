import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Veuillez vous connecter pour accéder à cette fonctionnalité.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(labelText: 'Email'),
            onChanged: (value) => session.email = value,
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onChanged: (value) => session.password = value,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => session.login(),
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}
