import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import 'edit_field_dialog.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String fieldKey;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(value.isNotEmpty ? value : 'Non précisé'),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.deepPurple),
        onPressed: () => showEditDialog(context, title, value, fieldKey),
      ),
    );
  }
}
