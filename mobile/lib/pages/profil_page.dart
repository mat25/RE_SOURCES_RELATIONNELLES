import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../pages/settings_page.dart';
import '../pages/info_page.dart';
import '../pages/login_page.dart';
import '../widgets/profil/profil_header.dart';
import '../widgets/profil/profil_option_tile.dart';
import '../widgets/profil/logout_button.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return session.isLoggedIn
        ? Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfilHeader(user: session.user),
            const SizedBox(height: 20),
            ProfilOptionTile(
              icon: Icons.settings,
              title: 'Paramètres',
              subtitle: 'Modifier vos préférences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            ProfilOptionTile(
              icon: Icons.info_outline,
              title: 'Mes informations',
              subtitle: 'Modifier vos informations personnelles',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InfoPage()),
                );
              },
            ),
            ProfilOptionTile(
              icon: Icons.bar_chart,
              title: 'Progression',
              subtitle: 'Voir ma progression sur les ressources',
              onTap: () {
                // TODO
              },
            ),
            ProfilOptionTile(
              icon: Icons.info,
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
            const SizedBox(height: 30),
            LogoutButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    )
        : const LoginPage();
  }
}
