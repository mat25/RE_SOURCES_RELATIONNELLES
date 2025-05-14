import 'package:flutter/material.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'info_page.dart';
import 'login_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  void _showLoginSnackbar(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    if (session.loginMessage != null) {
      _showLoginSnackbar(context, session.loginMessage!);
      session.clearLoginMessage();
    }

    return session.isLoggedIn
        ? Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                    session.user?.name ?? 'Utilisateur',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    session.user?.email ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              context,
              icon: Icons.settings,
              title: 'Paramètres',
              subtitle: 'Modifier vos préférences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.info_outline,
              title: 'Mes informations',
              subtitle: 'Modifier vos informations personnelles',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.bar_chart,
              title: 'Progression',
              subtitle: 'Voir ma progression sur les resssources',
              onTap: () {
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.info_outline,
              title: 'À propos',
              subtitle: 'Informations sur l\'application',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Mon App",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2025 TonNom",
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.logout,
              title: 'Déconnexion',
              subtitle: 'Se déconnecter de votre compte',
              onTap: () => session.logout(),
              iconColor: Colors.red,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    )
        : const LoginPage();
  }

  Widget _buildOptionTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        Color iconColor = Colors.deepPurple,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
