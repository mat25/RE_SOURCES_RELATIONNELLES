import 'package:flutter/material.dart';

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Général',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
              },
              activeColor: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Langue'),
            subtitle: const Text('Français'),
            onTap: () => _showSnackBar(context, 'Changement de langue bientôt disponible'),
          ),
          const Divider(height: 32),

          const Text(
            'Confidentialité',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Changer le mot de passe'),
            onTap: () => _showSnackBar(context, 'Fonction à venir'),
          ),
          ListTile(
            leading: const Icon(Icons.shield),
            title: const Text('Politique de confidentialité'),
            onTap: () => _showSnackBar(context, 'Redirection vers la politique de confidentialité'),
          ),
          const Divider(height: 32),

          const Text(
            'À propos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('À propos de l\'application'),
            onTap: () => _showSnackBar(context, 'Version 1.0.0 - (RE)Sources Relationnelles'),
          ),
        ],
      ),
    );
  }
}
