import 'package:flutter/material.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'info_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: session.isLoggedIn
          ? SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepPurple.shade200,
                    backgroundImage: session.user?.avatar != null && session.user!.avatar!.isNotEmpty
                        ? NetworkImage(session.user!.avatar!)
                        : null,
                    child: session.user?.avatar == null || session.user!.avatar!.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.user?.name ?? 'Nom inconnu',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        session.user?.email ?? 'Email non disponible',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const Divider(thickness: 1),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.deepPurple),
                    title: const Text('Paramètres'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.deepPurple),
                    title: const Text('Mes informations'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InfoPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bar_chart, color: Colors.deepPurple),
                    title: const Text('Progression'),
                    onTap: () {
                      // TODO: Naviguer vers progression
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => session.logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text("Se déconnecter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
          : const LoginPage(),
    );
  }
}
