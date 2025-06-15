import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/info/delete_account_dialog.dart';
import '../widgets/info/edit_field_dialog.dart';
import '../widgets/info/change_password_dialog.dart';
import '../widgets/info/info_tile.dart';
import '../widgets/info/user_card.dart';
import '../widgets/info/section_title.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);
    final user = session.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Aucune information disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Informations'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          UserCard(user: user),
          const SizedBox(height: 20),
          const SectionTitle('Informations personnelles'),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                InfoTile(
                  icon: Icons.account_circle,
                  title: 'Nom d’utilisateur',
                  value: user.username ?? '',
                  fieldKey: 'username',
                ),
                const Divider(height: 1),
                InfoTile(
                  icon: Icons.person,
                  title: 'Nom',
                  value: user.lastName ?? '',
                  fieldKey: 'name',
                ),
                const Divider(height: 1),
                InfoTile(
                  icon: Icons.person_outline,
                  title: 'Prénom',
                  value: user.firstName ?? '',
                  fieldKey: 'firstName',
                ),
                const Divider(height: 1),
                InfoTile(
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email ?? '',
                  fieldKey: 'email',
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.deepPurple),
                  title: const Text('Mot de passe'),
                  subtitle: const Text('••••••••'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                    onPressed: () => showPasswordChangeDialog(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => showDeleteAccountDialog(context, session),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Supprimer mon compte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
