import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  void _showEditDialog(BuildContext context, String fieldName, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    final session = Provider.of<SessionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Modifier $fieldName'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Nouveau $fieldName',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            label: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty && newValue != currentValue) {
                String apiField = _getApiFieldName(fieldName);
                try {
                  await session.updateProfileField(apiField, newValue);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$fieldName mis à jour avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur : $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  String _getApiFieldName(String label) {
    switch (label) {
      case 'Nom':
        return 'name';
      case 'Prénom':
        return 'firstName';
      case 'Email':
        return 'email';
      case 'Nom d’utilisateur':
        return 'username';
      default:
        return label.toLowerCase();
    }
  }

  void _showPasswordChangeDialog(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe actuel'),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('Modifier', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // TODO: appel API pour changer le mot de passe
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mot de passe mis à jour (fictivement)'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Supprimer le compte'),
        content: const Text('Cette action est irréversible. Êtes-vous sûr(e) de vouloir supprimer votre compte ?'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // TODO: appel API pour supprimer le compte
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Compte supprimé (fictivement)'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        bool editable = true,
        VoidCallback? onEdit,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(value.isNotEmpty ? value : 'Non précisé'),
      trailing: editable
          ? IconButton(
        icon: const Icon(Icons.edit, color: Colors.deepPurple),
        onPressed: onEdit,
      )
          : null,
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
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: user == null
          ? const Center(child: Text('Aucune information disponible'))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    user.username ?? 'Nom d’utilisateur',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Informations personnelles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildInfoTile(
                  context,
                  icon: Icons.account_circle,
                  title: 'Nom d’utilisateur',
                  value: user.username ?? '',
                  onEdit: () => _showEditDialog(context, 'Nom d’utilisateur', user.username ?? ''),
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  context,
                  icon: Icons.person,
                  title: 'Nom',
                  value: user.name ?? '',
                  onEdit: () => _showEditDialog(context, 'Nom', user.name ?? ''),
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  context,
                  icon: Icons.person_outline,
                  title: 'Prénom',
                  value: user.firstName ?? '',
                  onEdit: () => _showEditDialog(context, 'Prénom', user.firstName ?? ''),
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  context,
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email ?? '',
                  onEdit: () => _showEditDialog(context, 'Email', user.email ?? ''),
                ),
                const Divider(height: 1),
                _buildInfoTile(
                  context,
                  icon: Icons.lock,
                  title: 'Mot de passe',
                  value: '••••••••',
                  onEdit: () => _showPasswordChangeDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showDeleteAccountDialog(context),
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
