import 'package:flutter/material.dart';
import '../widgets/settings/settings_section_title.dart';
import '../widgets/settings/settings_card.dart';
import '../widgets/settings/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          const SettingsSectionTitle('Général'),
          SettingsCard(
            tiles: [
              SettingsTile.switchTile(
                icon: Icons.notifications,
                title: 'Notifications',
                value: true,
                onChanged: (_) {},
              ),
              SettingsTile.simpleTile(
                icon: Icons.language,
                title: 'Langue',
                subtitle: 'Français',
                onTap: () => _showSnackBar(context, 'Changement de langue bientôt disponible'),
              ),
            ],
          ),
          const SettingsSectionTitle('Confidentialité'),
          SettingsCard(
            tiles: [
              SettingsTile.simpleTile(
                icon: Icons.lock,
                title: 'Changer le mot de passe',
                onTap: () => _showSnackBar(context, 'Fonction à venir'),
              ),
              SettingsTile.simpleTile(
                icon: Icons.shield,
                title: 'Politique de confidentialité',
                onTap: () => _showSnackBar(context, 'Redirection vers la politique de confidentialité'),
              ),
            ],
          ),
          const SettingsSectionTitle('À propos'),
          SettingsCard(
            tiles: [
              SettingsTile.simpleTile(
                icon: Icons.info,
                title: 'À propos de l\'application',
                onTap: () => _showSnackBar(context, 'Version 1.0.0 - (RE)Sources Relationnelles'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              "Merci d'utiliser notre app !",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
