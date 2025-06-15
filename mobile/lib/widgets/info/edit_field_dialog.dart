import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';

void showEditDialog(BuildContext context, String fieldName, String currentValue, String fieldKey) {
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
          icon: const Icon(Icons.save),
          label: const Text('Enregistrer'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
          onPressed: () async {
            final newValue = controller.text.trim();
            Navigator.pop(context);
            if (newValue.isEmpty || newValue == currentValue) return;

            final success = await session.updateProfileField(fieldKey, newValue);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? '$fieldName mis à jour avec succès'
                    : 'Erreur lors de la mise à jour de $fieldName'),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          },
        ),
      ],
    ),
  );
}
