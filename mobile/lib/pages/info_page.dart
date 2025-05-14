import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  void _showEditDialog(BuildContext context, String fieldName) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Modifier $fieldName'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Nouveau $fieldName',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text(
              'Enregistrer',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$fieldName mis à jour'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);
    final user = session.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Informations'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(child: Text('Aucune information disponible'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatar ?? ''),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                user.name ?? 'Nom inconnu',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                user.email ?? 'Email non disponible',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Détails du compte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Nom complet'),
              subtitle: Text(user.name ?? 'Non précisé'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _showEditDialog(context, 'Nom complet'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Adresse e-mail'),
              subtitle: Text(user.email ?? 'Non précisé'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _showEditDialog(context, 'Adresse e-mail'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
