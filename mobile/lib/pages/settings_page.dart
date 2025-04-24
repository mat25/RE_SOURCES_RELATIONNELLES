import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/login_form.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Scaffold(
      body: session.isLoggedIn
          ? Center(
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(session.user?.avatar ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              session.user?.name ?? 'Nom inconnu',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              session.user?.email ?? 'Email non disponible',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => session.logout(),
              child: const Text("Se déconnecter"),
            ),
                    ],
                  ),
          )
          : const LoginForm(),
    );
  }
}
